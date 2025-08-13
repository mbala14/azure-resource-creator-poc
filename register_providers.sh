# List of commonly required providers for typical Terraform Azure resources
providers=(
  "Microsoft.Resources"
  "Microsoft.Storage"
  "Microsoft.Compute"
  "Microsoft.Network"
  "Microsoft.Sql"
)

echo "Checking and registering Azure resource providers..."

for provider in "${providers[@]}"; do
  state=$(az provider show --namespace "$provider" --query registrationState -o tsv)
  echo "Provider $provider status: $state"

  if [[ "$state" != "Registered" ]]; then
    echo "Registering $provider..."
    az provider register --namespace "$provider"
  fi
done

echo "Waiting for all providers to be registered..."

# Wait until all providers are registered
all_registered=false
while [ "$all_registered" = false ]; do
  all_registered=true
  for provider in "${providers[@]}"; do
    state=$(az provider show --namespace "$provider" --query registrationState -o tsv)
    if [[ "$state" != "Registered" ]]; then
      echo "Provider $provider still registering..."
      all_registered=false
    fi
  done
  if [ "$all_registered" = false ]; then
    sleep 10
  fi
done

echo "All providers registered. You can now run Terraform safely."