# Comparison of Blue/Green Deployment and Container Deployment

## Introduction

This document compares two deployment approaches used for the KK Payments application. The first approach uses two separate environments where one serves customers while the other is prepared for the next release. The second approach packages the application into containers that run together in a cluster. Both approaches improve reliability, but they solve different operational challenges.

The blue/green approach focuses on releasing new versions safely with minimal interruption. If a problem is detected after the release, traffic is returned to the previous working version automatically. This greatly reduces downtime and protects customers from failed transactions.

The container approach packages the application together with everything it needs to run. Multiple copies of the application are kept available, allowing the platform to recover automatically if one copy fails. This improves availability and makes it easier to increase capacity when demand grows.

## Comparison

| Concern              | Blue/Green Deployment                                                                          | Container Deployment                                                                             |
| -------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Deployment mechanism | A new version is prepared in a separate environment before customer traffic is switched.       | New application containers are created and managed by the cluster.                               |
| Rollback mechanism   | Traffic is automatically returned to the previous environment if monitoring detects a failure. | Failed containers are automatically replaced while healthy containers continue serving requests. |
| Failure recovery     | Recovery depends on switching traffic back to the previous working environment.                | Recovery happens automatically by creating replacement containers when failures occur.           |
| Scaling              | Additional environments require more servers and manual preparation.                           | Additional application copies can be started quickly to handle increased demand.                 |

## Reliability

Both deployment approaches improve service reliability, but they do so in different ways.

The blue/green deployment provides confidence during software releases. Before a new version is exposed to customers, it is deployed into an inactive environment where it can be verified. Once it has been confirmed to be healthy, customer traffic is redirected to the new version. If monitoring later detects a serious problem, traffic is automatically returned to the previous version. This reduces downtime and prevents customers from experiencing long service interruptions.

The container deployment focuses on keeping the application available even when failures occur. Instead of relying on only one running instance, multiple copies of the application are kept active. If one copy fails unexpectedly, another continues serving requests while the failed copy is replaced automatically. This allows the service to recover without requiring manual intervention.

## Evidence

The deployment exercises produced measurable improvements.

During testing, the application recovered from a failed container in **XX seconds**. This demonstrated the platform's ability to restore capacity automatically after a failure.

The production container image was also significantly smaller than the original build. The original image size was **XX MB**, while the optimized production image was **XX MB**. The smaller image reduces storage usage, decreases download time, and allows deployments to complete more quickly.

## Business Value

From a business perspective, both approaches reduce operational risk.

The blue/green deployment reduces the chance that customers experience failed transactions during software releases. New versions can be introduced safely, and problems can be corrected quickly through automatic rollback.

The container approach improves service availability by continuously monitoring running applications and replacing failed instances. This reduces manual work for engineers and allows the system to remain available even when individual application instances fail.

Together, these approaches increase customer confidence, reduce downtime, and improve the reliability of the payment platform.

## Current Limitations

Although the container deployment improves reliability, it does not solve every operational challenge. Application configuration, sensitive credentials, and environment-specific settings are still stored separately and require careful management. Container deployment also does not automatically manage application configuration across different environments.

The next project introduces Kubernetes orchestration features that improve configuration management, secret handling, and application lifecycle management. These additions make deployments easier to manage, improve security, and provide a more complete production-ready platform.
