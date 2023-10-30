#!/bin/bash
sourceFile=$1
sourceEnvs=$2

cp "$sourceFile" "build_gateway.yml"

while read line; do
    IFS='='
    read -a strarr <<< "$line"
    key="${strarr[0]}"
    new_value="${strarr[1]}"
    if [[ $key != "" && $new_value != "" ]]; then
        sed "s#$key#$new_value#" "build_gateway.yml" > "build_gateway_tmp.yml"
        echo " ${key} => ${new_value} "
        rm -rf "build_gateway.yml"
        cp "build_gateway_tmp.yml" "build_gateway.yml"
    fi
done < "$sourceEnvs"

rm -rf "build_gateway_tmp.yml"
