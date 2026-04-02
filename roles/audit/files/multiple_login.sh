#!/bin/bash
echo "Iniciando simulacro de fuerza bruta..."
for i in {1..10}
do
   # Intentamos cambiar a un usuario que no existe con una clave falsa
   su usuario_no_existe <<EOF
password_falsa
EOF

done
echo "Simulacro terminado. Revisa 'Threat Hunting' en el Dashboard."

exit 0