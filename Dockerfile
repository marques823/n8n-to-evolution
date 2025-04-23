FROM n8nio/n8n:latest

# Atualizado para a versão mais recente do n8n
USER root

# Instala dependências adicionais se necessário
RUN apk add --update --no-cache \
    python3 \
    make \
    g++ \
    su-exec \
    && rm -rf /var/cache/apk/*

# Configura o n8n
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Define o ponto de entrada
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"] 