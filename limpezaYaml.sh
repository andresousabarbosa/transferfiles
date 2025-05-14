#!/bin/bash

# Diretório onde os arquivos YAML estão localizados
diretorio=$(pwd)

# Campos a serem removidos (adaptado para migração)
campos_para_remover=(
  .metadata.resourceVersion
  .metadata.uid
  .metadata.creationTimestamp
  .metadata.generation
  .metadata.managedFields
  .status
  #.spec.clusterIP # Remova o IP do serviço
  #.spec.nodeName    # Remova o nome do nó do pod
  #.spec.hostIP      # Remove host IP
)

# Função para remover campos com yq
remover_campos() {
  local arquivo="$1"
  for campo in "${campos_para_remover[@]}"; do
    yq -i "del($campo)" "$arquivo"
  done
}

# Encontra todos os arquivos .yaml e .yml no diretório e subdiretórios
find "$diretorio" -name "*.yaml" -o -name "*.yml" | while read -r arquivo; do
  remover_campos "$arquivo"
  echo "Limpeza de metadados em: $arquivo"
done

echo "Limpeza dos arquivos YAML concluída."