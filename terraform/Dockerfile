FROM amazon/aws-cli:2.7.16

WORKDIR /usr/bin
ARG TERRAFORM_VERSION=1.2.5
RUN yum list | grep git-all
RUN yum upgrade -y
RUN yum list | grep git-all
RUN yum install -y unzip-6.0-43.amzn2 tar-1.26 gzip-1.5 git-1.8.3.1-23.el7_8.x86_64 \
  && yum clean all \
  && curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /work
COPY . .
ENTRYPOINT [ "./bin/entrypoint.sh" ]
