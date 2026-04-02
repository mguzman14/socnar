#!/bin/bash
echo "Simulando reconocimiento del sistema (Recon)..."
whoami
cat /etc/passwd
cat /etc/shadow 2>/dev/null  # Esto generará un error de permiso denegado que Wazuh verá
find / -perm -4000 -type f 2>/dev/null # Busca archivos con bit SUID (típico de escalada de privilegios)

exit 0