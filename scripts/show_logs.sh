#!/bin/bash

docker compose exec -T bbf bash -c 'tail -f /var/lib/postgresql/data/log/*'