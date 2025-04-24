# N8N com Evolution API - Versão Corrigida

Esta é uma versão corrigida da integração N8N com a Evolution API. Os principais problemas corrigidos nesta versão são:
1. O endpoint incorreto para envio de mensagens de texto
2. Problemas com webhooks travando na fila

## Problemas Corrigidos

### 1. Endpoint de Envio de Mensagens

O pacote `n8n-nodes-evolution-api` estava usando o endpoint incorreto para enviar mensagens de texto:
- **Endpoint incorreto:** `/manager/message/sendText/{instanceName}`
- **Endpoint correto:** `/message/sendText/{instanceName}`

Esta correção permite que o nó da Evolution API no N8N envie mensagens de texto corretamente, evitando o erro 404.

### 2. Webhooks Travando na Fila

Foram implementadas melhorias na configuração do Docker para evitar problemas com webhooks travando na fila de espera:
- Ativação dos runners de tarefas
- Configuração apropriada dos workers
- Ajustes nos timeouts de webhooks
- Configuração correta da limpeza de jobs travados

## Correções Aplicadas

### Correção do Endpoint

A correção foi aplicada no arquivo `sendText.js` do pacote `n8n-nodes-evolution-api`. O arquivo de patch `evolution-api-fix.patch` contém a alteração específica.

Para aplicar manualmente esta correção em uma instalação existente:

```bash
docker exec -it n8n-setup_n8n_1 sh -c "sed -i 's|/manager/message/sendText/|/message/sendText/|g' /home/node/.n8n/custom/node_modules/n8n-nodes-evolution-api/dist/nodes/EvolutionApi/execute/messages/sendText.js"
docker restart n8n-setup_n8n_1
```

### Correção dos Webhooks

A configuração do docker-compose.yml foi atualizada com as seguintes melhorias:
- Ativação dos runners com `N8N_RUNNERS_ENABLED: "true"`
- Configuração para enviar execuções manuais para workers com `OFFLOAD_MANUAL_EXECUTIONS_TO_WORKERS: "true"`
- Aumento do timeout de webhooks para 40 segundos com `WEBHOOK_TIMEOUT: "40000"`
- Configuração para expirar automaticamente jobs travados após 30 minutos com `N8N_REDIS_STALLED_JOB_EXPIRATION: "1800"`
- Limite de jobs por worker com `N8N_QUEUE_BULL_MEMORY_MAX_JOB_PER_WORKER: "10"`
- Configuração para marcar jobs como mortos após 2 segundos com `N8N_QUEUE_BULL_DEAD_JOB_AFTER: "2000"`
- Correção no comando do worker para usar o entrypoint correto

## Instalação

### Pré-requisitos

- Docker
- Docker Compose

### Passos

1. Clone este repositório:
```bash
git clone https://github.com/marques823/n8n-to-evolution.git
cd n8n-to-evolution
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

## Solução de problemas

### Problemas com os Nós da Evolution API

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

### Problemas com Webhooks

Se os webhooks ainda estiverem travando na fila de espera:

1. Verifique os logs do worker:
```bash
docker logs n8n-setup_n8n-worker_1
```

2. Limpe as execuções pendentes através da interface web do n8n (Settings -> Executions)

3. Verifique se há problemas específicos em seu workflow que possam estar causando timeouts
