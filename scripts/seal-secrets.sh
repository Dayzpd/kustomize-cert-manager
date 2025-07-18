#!/bin/bash

secretName="cloudflare-token"
envFile="secrets/cloudflare.env"
sealedSecretFile="resources/mgmt/sealed-secrets.yaml"
namespace="cert-manager"

certFile="secrets/sealed-secrets.crt"
tempDir="./.temp"
secretFile="$tempDir/secret.yaml"

mkdir -p $tempDir

kubectl create secret generic $secretName \
  --from-env-file=$envFile \
  --dry-run=client \
  --output yaml > $secretFile

kubeseal \
  --cert $certFile \
  --secret-file $secretFile \
  --sealed-secret-file $sealedSecretFile \
  --namespace $namespace \
  --scope namespace-wide

rm -rf $tempDir