#!/bin/bash
TARGET="/etc/wazuh_fake_config.conf"
echo "Simulando cambio de configuración crítica..."

sudo touch $TARGET
echo "Añadiendo contenido malicioso..." | sudo tee -a $TARGET
sudo chmod 777 $TARGET

sudo rm $TARGET

echo "FIM debería haber capturado la creación, edición y borrado."

exit 0