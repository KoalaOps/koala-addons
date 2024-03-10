# KoalaOps Addons Repository

Welcome to the KoalaOps Addons Repository! Our team leverages this repository to enhance the interoperability between various standard and popular operational tools such as Grafana, NGINX, OpenTelemetry (otel), and others. By creating wrapper Helm charts and Argo CD application CRDs, we facilitate a smoother integration and management process for these tools within our addons market.

## Repository Structure

This repository is organized into two main directories:

- `charts/`: Contains Helm chart wrappers for open-source tools. These charts are designed to provide custom configurations and integrations that are tailored to custom use cases.

- `argo-apps/`: Houses Argo CD Application Custom Resource Definitions (CRDs) which are also charts. This directory acts as a marketplace of add-ons for Argo, enabling easy deployment and management of our toolset within Argo-managed Kubernetes clusters.
