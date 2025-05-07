FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y docker.io awscli curl gnupg unzip wget

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu

RUN wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip && \
    unzip terraform_1.6.6_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.6.6_linux_amd64.zip

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
