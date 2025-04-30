#!/bin/bash
set -e

echo "entrando al entrypoint como : $(whoami)"
chown -R jenkins:jenkins /var/jenkins_home

if [ -S /var/run/docker.sock ]; then
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
fi

usermod -aG docker jenkins

exec gosu  jenkins /usr/bin/tini -- /usr/local/bin/jenkins.sh "$@"