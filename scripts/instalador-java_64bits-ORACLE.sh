#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo -e "Você não é root !!!\n"
  exit
fi

echo -e "\n\nInstalando versão mais recente do JAVA 64bits (oracle)\n"

echo -e "\nBaixando nova versão..."
URL=`wget http://www.java.com/pt_BR/download/linux_manual.jsp -q -O - |grep -Po '(?<=Linux x64" href=")[^"]*' | head -n 1`
wget --output-document=java-new.tar.gz "$URL" -q --show-progress
echo "OK"

echo -e "\nRemovendo versão anterior..."
mkdir /usr/local/java/
rm -rf /usr/local/java/*
echo "OK"

echo -e "\nExtraindo nova versão..."
tar xzf java-new.tar.gz -C /usr/local/java/
echo "OK"

echo -e "\nDefinindo nova versão como padrão..."
VERSAO=`echo /usr/local/java/* | awk -F  '/' ' {print $5}'`
update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/$VERSAO/bin/java" 1
update-alternatives --set java /usr/local/java/$VERSAO/bin/java
echo "OK"

echo -e "\nInstalando Plugin no Firefox..."
rm /usr/lib/mozilla/plugins/libnpjp2.so
rm java-new.tar.gz
cd /usr/lib/mozilla/plugins
find /usr/local/java -name 'libnpjp2.so' -exec echo {} \; | xargs ln -s 
killall -9 firefox
echo "OK"
echo -e "\nJAVA INSTALADO COM SUCESSO!\n"
echo -e "Acesse com o Firefox:\nhttps://www.java.com/en/download/installed.jsp\ne verifique a instalação.\n"
exit
