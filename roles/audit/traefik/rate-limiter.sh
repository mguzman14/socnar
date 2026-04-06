#!/bin/bash

CMD="hey -n 1000 -c 50 -t 10 http://juice.soc"

echo -e "[+] AUDIT | Rate limiter:\n\n$CMD\n"
echo -e "[+] Resultado:\n"

# Ejecutamos el comando
$CMD

