#!/bin/bash
echo -e "[+] AUDIT | Rate limiter:\n\n$CMD\n"
CMD="hey -n 1000 -c 50 -t 10 http://juice.soc"
echo -e "[+] Resultado:\n"
$CMD



echo -e "[+] AUDIT | Mira si Crowdsec te ha baneado:\n\n$CMD\n"
CMD="docker exec crowdsec cscli decisions list"
echo -e "[+] Resultado:\n"
$CMD