#!/bin/bash
if [ $USER = root ] ; then
    echo -e "\e[1;33;41mplease exit root and then execute this shell\e[0m\n"
    exit
fi

PROJ="stf-steper"
PROJDIR="${HOME}/${PROJ}"
echo -e "\e[1;32m-----------------PROJDIR:${PROJDIR}-----------------\e[0m"

cd $HOME
echo -e "\e[1;32m-----------------start do apt-get update-----------------\e[0m"
sudo apt-get update -y

#replace your proxy
export https_proxy=http://192.168.1.163:7890
export http_proxy=http://192.168.1.163:7890
export all_proxy=socks5://192.168.1.163:7890

sudo rm -f lock-frontend 
echo -e "\e[1;32m-----------------start sudo apt install python3-pip-----------------\e[0m"
sudo apt install python3-pip -y
echo -e "\e[1;32m-----------------start pip3 install -U tidevice-----------------\e[0m"
pip3 install -U tidevice
echo -e "\e[1;32m-----------------sudo apt install git-----------------\e[0m"
sudo apt install git -y
echo -e "\e[1;32m-----------------sudo apt install gcc patch-----------------\e[0m"
sudo apt install gcc patch -y

echo -e "\e[1;32m-----------------sudo apt install build-essential-----------------\e[0m"
sudo apt install build-essential -y
echo -e "\e[1;32m-----------------$(g++ --version)-----------------\e[0m"


echo -e "\e[1;32m-----------------sudo apt-get install gfortran-----------------\e[0m"
sudo apt-get install gfortran -y
echo -e "\e[1;32m-----------------sudo apt-get install libzmq-dev-----------------\e[0m"
sudo apt-get install libzmq-dev -y
echo -e "\e[1;32m-----------------sudo apt-get install -y libimobiledevice-dev-----------------\e[0m"
sudo apt-get install -y libimobiledevice-dev -y
echo -e "\e[1;32m-----------------sudo apt install ideviceinstaller-----------------\e[0m"
sudo apt install ideviceinstaller -y



if [ ! -d "${PROJDIR}" ]; then
    cd $HOME
    echo -e "\e[1;32m-----------------git clone https://github.com/cmdszh/stf-steper-----------------\e[0m"
    git clone https://github.com/cmdszh/stf-steper
    chown -R yyhd:yyhd ${PROJDIR}
fi

cd ${PROJDIR}
echo -e "\e[1;32m-----------------tf-steper path: ${pwd}-----------------\e[0m"

echo -e "\e[1;32m-----------------npm install-----------------\e[0m"
npm install

echo -e "\e[1;32m-----------------start check if stf install success-----------------\e[0m"

./bin/stf doctor

echo -e "\e[1;32m-----------------FINISHED-----------------\e[0m"
