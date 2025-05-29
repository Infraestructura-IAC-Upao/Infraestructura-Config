FROM jenkins/inbound-agent:latest

USER root


RUN id jenkins || useradd -m -d /home/jenkins -s /bin/bash jenkins


RUN apt-get update && apt-get install -y \
    openssh-client \
    curl \
    unzip \
 && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
 && unzip /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /home/jenkins/.ssh && chmod 700 /home/jenkins/.ssh && chown -R jenkins:jenkins /home/jenkins/.ssh

USER jenkins
