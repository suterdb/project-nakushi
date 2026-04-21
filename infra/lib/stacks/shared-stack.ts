import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import { Construct } from 'constructs';
import { NakushiDatabase } from '../constructs/NakushiDatabase';

/**
 * SharedStack — 모든 Nakushi 서비스가 공유하는 인프라
 *
 * - VPC (퍼블릭 + 프라이빗 서브넷)
 * - RDS PostgreSQL (서비스별 스키마 분리)
 *
 * 신규 서비스 스택은 이 스택을 props로 받아 DB와 VPC를 참조한다.
 */
export class SharedStack extends cdk.Stack {
  public readonly vpc: ec2.Vpc;
  public readonly database: NakushiDatabase;

  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    this.vpc = new ec2.Vpc(this, 'NakushiVpc', {
      maxAzs: 2,
      natGateways: 1,
      subnetConfiguration: [
        {
          name: 'Public',
          subnetType: ec2.SubnetType.PUBLIC,
          cidrMask: 24,
        },
        {
          name: 'Private',
          subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS,
          cidrMask: 24,
        },
      ],
    });

    this.database = new NakushiDatabase(this, 'NakushiDatabase', {
      vpc: this.vpc,
    });

    new cdk.CfnOutput(this, 'VpcId', { value: this.vpc.vpcId });
    new cdk.CfnOutput(this, 'DbEndpoint', {
      value: this.database.instance.instanceEndpoint.hostname,
    });
  }
}
