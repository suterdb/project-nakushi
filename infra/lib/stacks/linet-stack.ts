import * as cdk from 'aws-cdk-lib';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as amplify from '@aws-cdk/aws-amplify-alpha';
import * as codebuild from 'aws-cdk-lib/aws-codebuild';
import { Construct } from 'constructs';
import { SharedStack } from './shared-stack';
import { NakushiLLM } from '../constructs/NakushiLLM';

export interface LinetStackProps extends cdk.StackProps {
  sharedStack: SharedStack;
  /** GitHub 소스 연결 ARN (AWS Console > CodeStar Connections) */
  githubConnectionArn: string;
  /** GitHub 레포 소유자 */
  githubOwner: string;
  /** GitHub 레포 이름 */
  githubRepo: string;
  /** 배포 브랜치 */
  branch?: string;
}

/**
 * LinetStack — Linet 서비스 전용 리소스
 *
 * - Amplify 앱 (Next.js)
 * - Bedrock IAM 권한 (Claude Haiku 태그 추천)
 * - 환경변수 SSM 참조
 */
export class LinetStack extends cdk.Stack {
  public readonly amplifyApp: amplify.App;

  constructor(scope: Construct, id: string, props: LinetStackProps) {
    super(scope, id, props);

    const { sharedStack } = props;

    // Amplify 실행 IAM Role
    const amplifyRole = new iam.Role(this, 'AmplifyRole', {
      assumedBy: new iam.ServicePrincipal('amplify.amazonaws.com'),
    });

    // Bedrock 권한 부여
    new NakushiLLM(this, 'LinetLLM', {
      grantTo: amplifyRole,
    });

    // SSM에서 DB 시크릿 ARN 참조
    const dbSecretArn = sharedStack.database.instance.secret?.secretArn ?? '';

    // DB 시크릿 읽기 권한
    if (sharedStack.database.instance.secret) {
      sharedStack.database.instance.secret.grantRead(amplifyRole);
    }

    // Amplify 앱
    this.amplifyApp = new amplify.App(this, 'LinetApp', {
      appName: 'linet',
      role: amplifyRole,
      sourceCodeProvider: new amplify.GitHubSourceCodeProvider({
        owner: props.githubOwner,
        repository: props.githubRepo,
        oauthToken: cdk.SecretValue.ssmSecure('/nakushi/github/token'),
      }),
      buildSpec: codebuild.BuildSpec.fromObjectToYaml({
        version: '1.0',
        frontend: {
          phases: {
            preBuild: { commands: ['npm ci'] },
            build: { commands: ['npm run build'] },
          },
          artifacts: {
            baseDirectory: '.next',
            files: ['**/*'],
          },
          cache: { paths: ['node_modules/**/*'] },
        },
      }),
      environmentVariables: {
        NEXT_PUBLIC_APP_NAME: 'linet',
        DATABASE_SECRET_ARN: dbSecretArn,
        BEDROCK_REGION: this.region,
        BEDROCK_MODEL_ID: 'anthropic.claude-haiku-4-5-20251001-v1:0',
      },
      platform: amplify.Platform.WEB_COMPUTE, // Next.js SSR 지원
    });

    // 배포 브랜치 연결
    const branch = this.amplifyApp.addBranch(props.branch ?? 'feature/Linet', {
      autoBuild: true,
      stage: 'DEVELOPMENT',
    });

    new cdk.CfnOutput(this, 'AmplifyAppId', {
      value: this.amplifyApp.appId,
    });
    new cdk.CfnOutput(this, 'AmplifyDefaultDomain', {
      value: this.amplifyApp.defaultDomain,
    });
    new cdk.CfnOutput(this, 'BranchUrl', {
      value: `https://${branch.branchName}.${this.amplifyApp.defaultDomain}`,
    });
  }
}
