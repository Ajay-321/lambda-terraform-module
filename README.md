Securely Access GCP Resources from AWS Lambda using Workload Identity Federation

This guide explains how to configure an AWS Lambda function running in a private subnet to securely access Google Cloud Storage (GCS) and Google Pub/Sub resources using Workload Identity Federation (WIF).
The solution ensures keyless authentication — no long-lived GCP service account keys are stored or managed.

🚀 Overview

Workload Identity Federation (WIF) allows AWS workloads (e.g., Lambda, EC2, EKS) to exchange their native AWS identity for short-lived Google Cloud credentials via the Google Security Token Service.

Workflow:

Lambda assumes an AWS IAM role.

AWS STS issues a token for that role.

Google STS validates the AWS token via WIF provider.

A short-lived GCP access token is issued.

Lambda uses this token to access GCS buckets and Pub/Sub topics.

Benefits:

🔑 No long-lived service account keys.

🔒 Stronger security posture.

⚡ Simplified operations (no key rotation).


✅ Key Takeaways

Use Workload Identity Federation for secure cross-cloud authentication.

Always package GCP client libraries as a Lambda Layer.

Keep Lambda in a private subnet for enhanced security.

Manage access via IAM role bindings in GCP.

🔒 With this setup, your AWS Lambda can securely interact with Google Cloud resources (GCS, Pub/Sub) without static keys, leveraging modern identity federation.
