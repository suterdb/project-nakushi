import * as iam from 'aws-cdk-lib/aws-iam';
import { Construct } from 'constructs';

export interface NakushiLLMProps {
  /** Bedrock 모델 ID. 기본값: Claude Haiku */
  modelId?: string;
  /** 이 권한을 부여할 IAM Role */
  grantTo: iam.IGrantable;
}

/**
 * Amazon Bedrock 호출 권한을 부여하는 Construct.
 * 신규 서비스에서 LLM이 필요할 때 재사용한다.
 */
export class NakushiLLM extends Construct {
  public readonly modelId: string;

  constructor(scope: Construct, id: string, props: NakushiLLMProps) {
    super(scope, id);

    this.modelId =
      props.modelId ?? 'anthropic.claude-haiku-4-5-20251001-v1:0';

    props.grantTo.grantPrincipal.addToPrincipalPolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: ['bedrock:InvokeModel'],
        resources: [
          `arn:aws:bedrock:*::foundation-model/${this.modelId}`,
        ],
      }),
    );
  }
}
