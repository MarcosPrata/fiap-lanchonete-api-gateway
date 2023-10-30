#!/bin/bash

API_NAME=fiap-lanchonete-api-gateway
API_ID=api_gateway_id
REGION=us-east-1
STAGE=develop

echo
echo "// Criando API GATEWAY no localstack --------------------------" 

function fail() {
    echo $2
    exit $1
}

echo
echo "🟢 Criando API Gateway:"
nohup aws --endpoint="http://localhost:4566" apigateway create-rest-api \
    --tags '{"_custom_id_":"'${API_ID}'"}' \
    --region ${REGION} \
    --name ${API_NAME} \

[ $? == 0 ] || fail 1 "Failed: AWS / apigateway / create-rest-api"

echo
echo "🟢 Configurando variáveis de ambiente:"
sh ./scripts/use_envs.sh "./api/api-gateway-definition.yml" "./api/develop.env"

echo
echo "🟢 Configurando com o arquivo api-gateway-definition.yml:"
nohup aws --endpoint="http://localhost:4566" apigateway put-rest-api \
    --rest-api-id ${API_ID} \
    --mode overwrite \
    --body fileb://build_gateway.yml \

[ $? == 0 ] || fail 2 "Failed: AWS / apigateway / create-deployment"

rm build_gateway.yml

echo
echo "🟢 Fazendo deploy do API Gateway no localstack:"
nohup aws --endpoint="http://localhost:4566" apigateway create-deployment \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --stage-name ${STAGE} \

[ $? == 0 ] || fail 3 "Failed: AWS / apigateway / create-deployment"

echo
echo "API Gateway criado com sucesso! 🚀" 
echo "Disponível em: http://localhost:4566/restapis/api_gateway_id/develop/_user_request_/"
echo

rm nohup.out