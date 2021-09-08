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

#try kill process
pkill node
pkill rethinkdb
pkill gnirehtet


echo -e "\e[1;32m-----------------sudo rm -f lock-frontend-----------------\e[0m"
sudo rm -f lock-frontend 

echo -e "\e[1;32m-----------------install Nodejs 8.x-----------------\e[0m"
if [ ! -d "/opt" ];then 
    sudo mkdir /opt
fi
cd /opt
wget https://nodejs.org/dist/v8.17.0/node-v8.17.0-linux-x64.tar.gz
sudo tar -xzvf node-v8.17.0-linux-x64.tar.gz
sudo mv node-v8.17.0-linux-x64 nodejs
sudo chown -R ${USER}:${USER} /opt/nodejs/

#设置环境变量到~/.profile
if ! grep -q "NODEJS_HOME" "${HOME}/.profile"; then
    sudo echo "export NODEJS_HOME=/opt/nodejs/bin" >> "${HOME}/.profile"
    sudo echo "export PATH=$PATH:$NODEJS_HOME" >> "${HOME}/.profile"
fi
. ${HOME}/.profile
#设置环境变量到~/.bashrc
if ! grep -q "NODEJS_HOME" "${HOME}/.bashrc"; then
    sudo echo "export NODEJS_HOME=/opt/nodejs/bin" >> "${HOME}/.profile"
    sudo echo "export PATH=$PATH:$NODEJS_HOME" >> "${HOME}/.profile"
fi
. ${HOME}/.bashrc

#设置root账户环境变量
if ! grep -q "NODEJS_HOME" "/etc/profile"; then
    sudo echo "export NODEJS_HOME=/opt/nodejs/bin" >> "${HOME}/.profile"
    sudo echo "export PATH=$PATH:$NODEJS_HOME" >> "${HOME}/.profile"
fi

#安装ifconfig 以便在rc.local中获取本机IP
sudo apt install net-tools -y

#install ABD
sudo apt install adb -y


#install gnirehtet
sudo apt install unzip -y
cd $HOME
if [ ! -d "$HOME/gnirehtet" ]; then
    wget https://github.com/Genymobile/gnirehtet/releases/download/v2.5/gnirehtet-rust-linux64-v2.5.zip
    unzip gnirehtet-rust-linux64-v2.5.zip
    mv gnirehtet-rust-linux64-v2.5 gnirehtet
    GNIREHTET_APK=${HOME}/gnirehtet/gnirehtet.apk ./gnirehtet autorun
fi


#install rethinkdb
source /etc/lsb-release && echo "deb https://download.rethinkdb.com/repository/ubuntu-$DISTRIB_CODENAME $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/repository/raw/pubkey.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install rethinkdb - y

#install cmake
sudo apt install cmake -y
sudo apt-get install g++ -y

#Install GraphicMagisc	
sudo apt install graphicsmagickze -y

#Install ZeroMQ
apt-get install libzmq3-dev -y

#Install Protocol Buffers libraries 
sudo apt install protobuf-compiler -y

#install yasm
sudo apt install yasm -y

#install pkg-config
sudo apt install pkg-config -y

echo -e "\e[1;32m-----------------node version:$(node -v)-----------------\e[0m" 

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
#
#echo -e "\e[1;32m-----------------add reboot-----------------\e[0m"
#if [ ! -f /etc/rc.local ]; then
#    echo "#!/bin/bash" |sudo tee -a /etc/rc.local
#    sudo echo ". /etc/profile">> /etc/rc.local
#    sudo echo "GNIREHTET_APK=${HOME}/gnirehtet/gnirehtet.apk ./gnirehtet autorun &" >> /etc/rc.local
#    sudo echo "rethinkdb --bind all & ">> /etc/rc.local
#    sudo echo "ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`">> /etc/rc.local
#    sudo echo '"stf local --public-ip $ip  --no-cleanup  --no-screen-reset &"'>> /etc/rc.local
#    sudo echo 'myurl="\"http://"${ip}":7100\""'>> /etc/rc.local
#    sudo echo "mytime=$(TZ=UTC-8 date +%Y-%m-%d" "%H:%M:%S)">> /etc/rc.local
#    sudo echo 'myhost="\"http://${ip}:7100 \nhost:${HOSTNAME} \ntime:$mytime \nserver started\""'>> /etc/rc.local
#    sudo echo 'mytitle="\"started (${HOSTNAME} ${ip})\""'>> /etc/rc.local
#    sudo echo "curl --location --request POST 'https://oapi.dingtalk.com/robot/send?access_token=b9477c6204e1b78e78a0f6447f4e9b09be19b600a8a067bdd596096a7b26e3eb' \ " >> /etc/rc.local
#    sudo echo "-H 'Content-Type: application/json' \ " >> /etc/rc.local
#    sudo echo '-d "$(cat <<EOF'  >> /etc/rc.local
#    sudo echo '{"msgtype": "link","link": {"text":$myhost,"title":$mytitle,"messageUrl":$myurl}}' >> /etc/rc.local
#    sudo echo 'EOF' >> /etc/rc.local
#    sudo echo ')" & ' >> /etc/rc.local
#    sudo echo "the computer booted up at" $mytime  "ip:" $ip >> "$HOME/bootup.log"
#fi

#cat /etc/rc.local

echo -e "\e[1;32m-----------------FINISHED-----------------\e[0m"
