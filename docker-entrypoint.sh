#!/bin/sh

app_data_dir="/home/node/.n8n"

if [ ! -d "$app_data_dir" ]; then
  mkdir -p "$app_data_dir"
fi

# Instala o node da evolution-api
if [ ! -d "$app_data_dir/custom" ]; then
  mkdir -p "$app_data_dir/custom"
  cd "$app_data_dir/custom"
  npm install n8n-nodes-evolution-api
fi

# Definindo permissões
chown -R node:node /home/node

# Se estivermos rodando como usuário root
if [ "$(id -u)" = "0" ]; then
  if [ "$#" -gt 0 ]; then
    # Got started with arguments
    exec su-exec node "$@"
  else
    # Got started without arguments
    exec su-exec node n8n
  fi
else
  # Já estamos rodando como node
  if [ "$#" -gt 0 ]; then
    exec "$@"
  else
    exec n8n
  fi
fi


