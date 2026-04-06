#!/bin/bash

# Extraemos de CrowdSec y lo mandamos DIRECTO al archivo del manager sin pasar por variables de Bash
docker exec crowdsec cscli decisions list -o json | jq -c '.[]' | \
docker exec -i wazuh.manager sh -c "cat > /var/ossec/logs/crowdsec_alerts.json"