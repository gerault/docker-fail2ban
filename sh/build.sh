#!/bin/bash

echo "Build de fail2ban"
docker build -t gerault/docker-fail2ban . --pull
