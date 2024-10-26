#!/bin/bash

docker compose exec -it bbf tsql -H localhost -p 1433 -P password -U bbf ${@}