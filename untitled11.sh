#!/bin/bash

# Carrega os dados do arquivo user_input.txt
source user_input.txt

# Função para instalar o Chrome Remote Desktop
installCRD() {
  wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
  dpkg --install chrome-remote-desktop_current_amd64.deb
  apt install --assume-yes --fix-broken
  echo "Chrome Remote Desktop Instalado"
}

# Função para instalar o Ambiente Desktop GNOME
installDesktopEnvironment() {
  export DEBIAN_FRONTEND=noninteractive
  apt install --assume-yes gnome-session gnome-terminal gdm3
  systemctl set-default graphical.target
  systemctl enable gdm3
  echo "GNOME Desktop Environment Instalado"
}

# Função para instalar o Google Chrome
installGoogleChrome() {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg --install google-chrome-stable_current_amd64.deb
  apt install --assume-yes --fix-broken
  echo "Google Chrome Instalado"
}

# Criação do novo usuário
useradd -m $username
adduser $username sudo
echo "$username:$password" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

# Atualização e instalação dos softwares
apt update
installCRD
installGoogleChrome
installDesktopEnvironment

# Adiciona o usuário ao grupo do Chrome Remote Desktop e inicia serviço
adduser $username chrome-remote-desktop
su - $username -c "$CRD_SSH_Code --pin=$Pin"
service chrome-remote-desktop start

# Informações finais
echo ".........................................................."
echo "Log in PIN : $Pin"
echo "User Name : $username"
echo "User Pass : $password"
echo ".........................................................."

# Mantém o script em execução (opcional)
while true; do sleep 1000; done
