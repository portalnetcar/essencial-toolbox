#!/bin/bash

# Fetch public IP
IP=$(curl -s https://httpbin.org/ip | jq -r .origin | cut -d',' -f1)

# Return as JSON
echo "{\"ip\": \"$IP/32\"}"

