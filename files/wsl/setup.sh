echo "Starting WSL setup..."

sudo useradd -m -p $(openssl passwd -1 $1) $2
echo $1 | sudo -u $2

cd

echo "Instaling ZSH..."
sudo apt install zsh