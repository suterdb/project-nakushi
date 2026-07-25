import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as rds from 'aws-cdk-lib/aws-rds';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import { Construct } from 'constructs';

export interface NakushiDatabaseProps {
  vpc: ec2.IVpc;
  instanceType?: ec2.InstanceType;
}

export class NakushiDatabase extends Construct {
  public readonly instance: rds.DatabaseInstance;
  public readonly secret: rds.DatabaseInstanceFromSnapshot['secret'];
  public readonly securityGroup: ec2.SecurityGroup;

  constructor(scope: Construct, id: string, props: NakushiDatabaseProps) {
    super(scope, id);

    this.securityGroup = new ec2.SecurityGroup(this, 'DbSG', {
      vpc: props.vpc,
      description: 'Nakushi RDS security group',
      allowAllOutbound: false,
    });

    this.instance = new rds.DatabaseInstance(this, 'Instance', {
      engine: rds.DatabaseInstanceEngine.postgres({
        version: rds.PostgresEngineVersion.VER_16,
      }),
      instanceType:
        props.instanceType ??
        ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.MICRO),
      vpc: props.vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS },
      securityGroups: [this.securityGroup],
      multiAz: false,
      allocatedStorage: 20,
      maxAllocatedStorage: 100,
      deletionProtection: false, // MVP — 운영 전환 시 true로 변경
      removalPolicy: cdk.RemovalPolicy.SNAPSHOT,
      databaseName: 'nakushi',
    });

    // DB 엔드포인트를 SSM에 저장 (서비스 스택에서 참조)
    new ssm.StringParameter(this, 'DbEndpoint', {
      parameterName: '/nakushi/shared/db-endpoint',
      stringValue: this.instance.instanceEndpoint.hostname,
    });

    new ssm.StringParameter(this, 'DbPort', {
      parameterName: '/nakushi/shared/db-port',
      stringValue: this.instance.instanceEndpoint.port.toString(),
    });
  }

  /**
   * 앱 서버 보안 그룹에서 DB 접근을 허용
   */
  allowFrom(appSG: ec2.ISecurityGroup) {
    this.securityGroup.addIngressRule(
      appSG,
      ec2.Port.tcp(5432),
      'Allow app server to connect to RDS',
    );
  }
}
