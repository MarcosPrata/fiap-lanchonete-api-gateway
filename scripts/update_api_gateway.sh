#!/bin/bash

API_ID=api_gateway_id
REGION=us-east-1
STAGE=develop

echo
echo "// Atualizando API GATEWAY do localstack --------------------------" 

function fail() {
    echo $2
    exit $1
}

echo
echo "🟢 Configurando variáveis de ambiente:"
sh ./scripts/use_envs.sh "./api/api-gateway-definition.yml" "./api/develop.env"

echo
echo "🟢 Configurando com o arquivo api-gateway-definition.yml:"
nohup aws --endpoint="http://localhost:4566" apigateway put-rest-api \
    --rest-api-id ${API_ID} \
    --mode overwrite \
    --body fileb://build_gateway.yml \

[ $? == 0 ] || fail 1 "Failed: AWS / apigateway / create-deployment"

rm build_gateway.yml

echo
echo "🟢 Fazendo deploy do API Gateway no localstack:"
nohup aws --endpoint="http://localhost:4566" apigateway create-deployment \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --stage-name ${STAGE} \

[ $? == 0 ] || fail 2 "Failed: AWS / apigateway / create-deployment"

rm nohup.out

echo
echo "API Gateway atualizado com sucesso! 🚀" 
echo "Disponível em: http://localhost:4566/restapis/api_gateway_id/develop/_user_request_/" 
echo