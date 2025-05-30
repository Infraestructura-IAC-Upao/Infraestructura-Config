#!/bin/bash

echo "➡Entering directory Estados"
cd Estados/
echo "🧹 Running 'terraform init'"
terraform init -input=false
 echo "Running 'terraform apply'"
terraform apply -auto-approve

echo "➡Entering directory Persistente"
cd ../Persistente/
echo "🧹 Running 'terraform init'"
terraform init -input=false
echo "Running 'terraform apply'"
terraform apply -auto-approve
echo "➡Entering directory Efimero"
cd ../Efimero/

echo "🧹 Running 'terraform init'"
terraform init -input=false
echo "Running 'terraform apply'"
terraform apply -auto-approve


 
