# OCA Repository Helm Chart

This Helm chart deploys the OCA Repository application on a Kubernetes cluster.

## Prerequisites

*   Kubernetes 1.19+
*   Helm 3.2.0+

## Chart Details

This chart will deploy the following resources:
*   A Deployment for the OCA Repository application.
*   A Service to expose the application within the cluster.
*   An optional Ingress to expose the application outside the cluster.
*   An optional PersistentVolumeClaim (PVC) for data persistence.
*   A ServiceAccount for the application.

## Installing the Chart

To install the chart, use the `helm install` or `helm upgrade --install` command.

### Example Installation

The following command installs the chart into the `marketplace` namespace and configures the Ingress to be available at `oca-repository.marketplace.my-domain.com`.

bash
helm upgrade --install oca-repository ./ \
  --namespace marketplace \
  --create-namespace \
  --set namespace=marketplace \
  --set ingress.enabled=true \
  --set ingress.hostBase=my-domain.com

Enabling TLS
To enable TLS for the Ingress, provide the name of a secret containing the certificate and key.
helm upgrade --install oca-repository ./ \
  --namespace marketplace \
  --create-namespace \
  --set namespace=marketplace \
  --set ingress.enabled=true \
  --set ingress.hostBase=my-domain.com \
  --set ingress.tlsSecret=my-tls-secret

Enabling Persistence
Persistence can be enabled to store data across pod restarts. This will create a PersistentVolumeClaim.

You can enable persistence by setting persistence.enabled to true or by using the values-persistent.yaml file.

Example using --set:
helm upgrade --install oca-repository ./ \
  --namespace marketplace \
  --create-namespace \
  --set persistence.enabled=true \
  --set persistence.size=10Gi

Example using values-persistent.yaml:
helm upgrade --install oca-repository ./ \
  --namespace marketplace \
  --create-namespace \
  -f values-persistent.yaml
