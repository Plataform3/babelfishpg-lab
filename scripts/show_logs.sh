#!/bin/bash

docker compose exec -T bbf bash -c 'cat /var/lib/postgresql/data/log/*'