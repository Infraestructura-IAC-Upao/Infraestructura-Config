#!/bin/bash

set -e

# Lista de carpetas que se destruirán
DIRS=("Efimero" "ElasticIP" "States")

echo "This will destroy all managed infrastructure in: ${DIRS[*]}"
echo -e "\nDo you really want to destroy all resources?"
read -p "  Type 'yes' to continue: " confirm

if [[ "$confirm" != "yes" ]]; then
  echo "Destroy cancelled."
  exit 0
fi

for dir in "${DIRS[@]}"; do
  echo "➡Entering directory: $dir"
  cd "$dir"

  echo "🧹 Running 'terraform init'"
  terraform init -input=false

  echo "Running 'terraform destroy'"
  terraform destroy -auto-approve

  cd ..
  echo " Destroyed: $dir"
  echo
done

echo "All resources have been successfully destroyed."
