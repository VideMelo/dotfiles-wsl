PASS=$1
USER=$2

if id "$USER" >/dev/null 2>&1; then
    echo "User $USER exists"
else
    sudo useradd -m -p $(openssl passwd -1 $PASS) $USER
    echo "$USER ALL=(ALL:ALL) ALL" >> /etc/sudoers
fi

sudo apt-get update -y
sudo apt-get upgrade -y

USERHOME="/home/$USER"
cp -r /root/dotfiles-wsl $USERHOME/dotfiles-wsl

su - $USER bash -c "sh ./dotfiles-wsl/files/wsl/setup.sh $PASS"