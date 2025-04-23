# N8N com Evolution API - Versão Corrigida

Esta é uma versão corrigida da integração N8N com a Evolution API. O principal problema corrigido nesta versão é o endpoint de envio de mensagens de texto que estava incorreto.

## O Problema Corrigido

O pacote `n8n-nodes-evolution-api` estava usando o endpoint incorreto para enviar mensagens de texto:
- **Endpoint incorreto:** `/manager/message/sendText/{instanceName}`
- **Endpoint correto:** `/message/sendText/{instanceName}`

Esta correção permite que o nó da Evolution API no N8N envie mensagens de texto corretamente, evitando o erro 404.

## Correção Aplicada

A correção foi aplicada no arquivo `sendText.js` do pacote `n8n-nodes-evolution-api`. O arquivo de patch `evolution-api-fix.patch` contém a alteração específica.

Para aplicar manualmente esta correção em uma instalação existente:

```bash
docker exec -it n8n-setup_n8n_1 sh -c "sed -i 's|/manager/message/sendText/|/message/sendText/|g' /home/node/.n8n/custom/node_modules/n8n-nodes-evolution-api/dist/nodes/EvolutionApi/execute/messages/sendText.js"
docker restart n8n-setup_n8n_1
```

## Instalação

### Pré-requisitos

- Docker
- Docker Compose

### Passos

1. Clone este repositório:
```bash
git clone https://github.com/seu-usuario/n8n-evolution-fix.git
cd n8n-evolution-fix
```

2. Copie o arquivo `.env.example` para `.env` e configure as variáveis conforme necessário:
```bash
cp .env.example .env
```

3. Crie a rede Docker para comunicação com a Evolution API:
```bash
docker network create evolution-network
```

4. Execute o Docker Compose para iniciar os serviços:
```bash
docker-compose up -d
```

5. Conecte o contêiner da Evolution API à rede do n8n (se ainda não estiver conectado):
```bash
docker network connect evolution-network evolution_api
```

## Utilização

Após a instalação, o nó da Evolution API estará disponível no n8n para utilização em seus workflows.

Para acessar o n8n, acesse `http://localhost:5678` ou o domínio configurado no arquivo `.env`.

## Solução de problemas

Se o nó da Evolution API não aparecer na interface do n8n:

1. Verifique se os contêineres estão em execução:
```bash
docker ps | grep n8n
```

2. Verifique os logs do n8n:
```bash
docker logs n8n-setup_n8n_1
```

3. Reinicie os contêineres:
```bash
docker-compose restart
```

4. Certifique-se de que o contêiner da Evolution API está na mesma rede:
```bash
docker network inspect evolution-network
```
