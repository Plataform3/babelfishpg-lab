#!/bin/bash

tdscli() {
    docker compose exec -T bbf tsql -H localhost -p 1433 -P password -U bbf master <<EOF
${1}    
EOF
}