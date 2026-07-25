#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { SharedStack } from '../lib/stacks/shared-stack';
import { LinetStack } from '../lib/stacks/linet-stack';

const app = new cdk.App();

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION ?? 'ap-northeast-2',
};

// 공유 인프라 (VPC + RDS) — 모든 서비스에서 참조
const sharedStack = new SharedStack(app, 'NakushiShared', { env });

// Linet 서비스 스택
new LinetStack(app, 'NakushiLinet', {
  env,
  sharedStack,
  githubConnectionArn: process.env.GITHUB_CONNECTION_ARN ?? '',
  githubOwner: 'suterdb',
  githubRepo: 'project-nakushi', // Linet 앱 레포로 변경 예정
  branch: 'feature/Linet',
});

// 신규 서비스 추가 시: new MirrorStack(app, 'NakushiMirror', { env, sharedStack, ... });
