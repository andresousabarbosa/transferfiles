#!/bin/bash

# Diretório onde os arquivos YAML estão localizados
diretorio=$(pwd)

# Campos a serem removidos para todos os tipos, exceto Deployment
campos_padrao=(
  .metadata.resourceVersion
  .metadata.uid
  .metadata.creationTimestamp
  .metadata.generation
  .metadata.managedFields
  .metadata.namespace
  .spec.clusterIP
  .spec.clusterIPs
  .status
)

# Campos a serem removidos especificamente para Deployment
campos_deployment=(
  .spec.template.metadata.annotations
  .spec.template.metadata.creationTimestamp
  .metadata.annotations # Remover annotations de Deployments
)

# Função para remover campos com yq
remover_campos() {
  local arquivo="$1"
  local tipo=$(yq e '.kind' "$arquivo") # Obtém o tipo do recurso
  tipo=${tipo%?} # Remove a última letra se for um caractere de nova linha

  local campos=()
  if [ "$tipo" = "Deployment" ]; then
    campos=("${campos_deployment[@]}")
  else
    campos=("${campos_padrao[@]}")
  fi

  if [ -n "$campos" ]; then
    for campo in "${campos[@]}"; do
      yq -i "del($campo)" "$arquivo"
    done
  else
    echo "Tipo de recurso desconhecido ou não configurado para limpeza: $tipo em $arquivo" >&2
  fi
}

# Encontra todos os arquivos .yaml e .yml no diretório e subdiretórios
find "$diretorio" -name "*.yaml" -o -name "*.yml" | while read -r arquivo; do
  remover_campos "$arquivo"
  echo "Limpeza de metadados em: $arquivo"
done

echo "Limpeza dos arquivos YAML concluída."
