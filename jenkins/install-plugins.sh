#!/bin/bash

PLUGIN_FILE=/usr/share/jenkins/ref/plugins.txt

jenkins-plugin-cli --plugin-file $PLUGIN_FILE

echo 'Plugins instalados...'