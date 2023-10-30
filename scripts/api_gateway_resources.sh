#!/bin/bash

API_ID=api_gateway_id
REGION=us-east-1
STAGE=develop

echo
echo "// API Gateway Resources --------------------------" 

rm ./scripts/api_gateway_resources.txt

nohup aws apigateway get-resources \
    --region us-east-1 \
    --rest-api-id ${API_ID} \
    --endpoint-url="http://localhost:4566" > ./scripts/api_gateway_resources.txt \

echo
echo "Recursos exibidos em: ./scripts/api_gateway_resources.txt" 
echo