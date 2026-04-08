#/bin/bash

echo -e "\n[+] Muestra las métricas:\n"
CMD="docker exec crowdsec cscli metrics"
echo -e "$CMD\n"
$CMD


