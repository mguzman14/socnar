  GNU nano 8.4                                                                                                crowdsec-scenario.sh *                                                                                                       
#!/bin/bash

# --- CONFIGURACIÓN ---
TARGET_IP="127.0.0.1"        # IP de tu servidor/contenedor
PORT="22"                    # Puerto SSH
USER="usuario_fake"          # Usuario que no existe
ATTEMPTS=10                  # Número de intentos


echo -e "[+] AUDIT | Probando el scenario crowdsecurity/http-probing (ssh $USER@$TARGET_IP)\n"

echo -e "[+] Reinicia la decision list:\n"
CMD="docker exec crowdsec cscli decisions delete --all"
echo -e "$CMD\n"
$CMD

echo -e "\n[+] Muestra ahora la decisions list \n"
CMD="docker exec crowdsec cscli decisions list"
echo -e "$CMD\n"
$CMD

echo -e "\n[+] Hace 10 intentos de log in con usuario inventado\n"
CMD="ssh -p $PORT -o ConnectTimeout=2 -o BatchMode=yes $USER@$TARGET_IP 2>/dev/null"
echo -e "$CMD\n"


for i in $(seq 1 $ATTEMPTS); do  

    echo $i;

    ssh -p $PORT -o ConnectTimeout=2 -o BatchMode=yes $USER@$TARGET_IP 2>/dev/null
    sleep 0.5
done

echo -e "[+] AUDIT | Mira si Crowdsec ha generado alertas:\n"
CMD="docker exec crowdsec cscli alerts list"
echo -e "$CMD\n"
echo -e "[+] Resultado:\n"
$CMD
