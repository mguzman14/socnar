  GNU nano 8.4                                                                                ip-ban.sh                                                                                         
#!/bin/bash

IP_A_BANEAR=${1:-"1.2.3.4"}
MOTIVO="test crowdsec IP ban"
DURACION="4h"

echo -e "\n[+] Reinicia la decisions.db\n"


CMD_DEL="docker exec crowdsec cscli decisions delete --all"
echo -e "$CMD_DEL\n"
$CMD_DEL

echo -e "\n\n[+] Banea la IP $IP_A_BANEAR\n"


CMD="docker exec crowdsec cscli decisions add --ip $IP_A_BANEAR --reason \"$MOTIVO\" --duration \"$DURACION\""

echo -e "$CMD\n"

eval "$CMD"

echo -e "\n[!] Verifica el resultado en los eventos de Wazuh (Explore/Discover)"
echo -e "[!] Verifica el resultado en Crowdsec (https://app.crowdsec.net/alerts)\n"