FROM alpine:3.18

ENV CURL_VERSION="8.5.0-r0"
ENV UNZIP_VERSION="6.0-r14"
ENV CA_CERTIFICATES_VERSION="20230506-r0"
ENV TERRAFORM_VERSION="1.6.5"
ENV TERRAGRUNT_VERSION="0.53.1"

ENV PROJECT_VERSION="1.0.0"
ENV PROJECT_AUTHOR="David Abarca"
ENV PROJECT_EMAIL="david.abarca@mechaconsulting.org"

# Setup prerequisites
RUN apk add --update --no-cache \
  curl=${CURL_VERSION} \
  unzip=${UNZIP_VERSION} \
  ca-certificates=${CA_CERTIFICATES_VERSION}

# Setup Terraform
RUN curl -fSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip \
  && unzip terraform.zip -d /usr/bin \
  && rm -f terraform.zip

# Setup Terragrunt
RUN curl -fSL https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt \
  && chmod +x /usr/local/bin/terragrunt

# Secure image
RUN adduser -D worker
USER worker
WORKDIR /home/worker

ENV PATH="/home/worker/.local/bin:${PATH}"

LABEL maintainer="${PROJECT_AUTHOR} ${PROJECT_EMAIL}" \
  version=${PROJECT_VERSION}
