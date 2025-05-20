#!/bin/bash
set -e

echo "entrando al entrypoint como : $(whoami)"
chown -R jenkins:jenkins /var/jenkins_home

if [ -S /var/run/docker.sock ]; then
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
fi

if [ -f /home/upao/.ssh/id_rsa ]; then
    echo "Configurando ~/.ssh/config para evitar prompts SSH..."
    mkdir -p /home/upao/.ssh
    cat > /home/upao/.ssh/config <<EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF
    chmod 600 /home/upao/.ssh/config
    chown jenkins:jenkins /home/upao/.ssh/config
fi

usermod -aG docker jenkins

exec gosu  jenkins /usr/bin/tini -- /usr/local/bin/jenkins.sh "$@"