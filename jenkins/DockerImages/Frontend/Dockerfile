FROM node:18

# AWS CLI y git
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk awscli git && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario 'jenkins'
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins

# Cambiar al usuario jenkins
USER jenkins

# Crear directorio de trabajo (necesario para Jenkins)
WORKDIR /home/jenkins

# Permitir acceso al bin
ENV PATH="/home/jenkins/.local/bin:${PATH}"

RUN mkdir -p /home/jenkins/.npm-global && \
    npm config set prefix '/home/jenkins/.npm-global'
ENV PATH="/home/jenkins/.npm-global/bin:${PATH}"