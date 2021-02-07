#!/bin/bash
#### Description: Script to build & manage RSA key easily  
#### Written by: Agus Prasetia - me@agusprasetia.com on 04-2016 
WKDIR="`pwd`" 
KEYS="$WKDIR/keys" 
CACERT="$WKDIR/pki/ca.crt" 
mkdir -p $KEYS 
if [ ! -d "pki" ]; then 
	$WKDIR/easyrsa init-pki 
	cp vars.example vars 
fi 
if [ ! -f "$CACERT" ] 
then 
	echo "Building CA cert & Key... " 
	$WKDIR/easyrsa build-ca 
	cp $CACERT $KEYS 
	cp $WKDIR/pki/private/ca.key $KEYS 
fi 
echo -e "Please Choose your certificate type" 
PS3="Please Pick your choice: 1)Server 2)Client 3)Gen-Pem 4)Quit " 
options=("Server" "Client" "Gen-Pem" "Quit") 
select opt in "${options[@]}" 
do 
	case $opt in 
		"Server") 
			echo -e "Type your SERVER unique name: " 
			read svrname 
			echo -e "Building Server Certificate.." 
			$WKDIR/easyrsa gen-req $svrname nopass 
			$WKDIR/easyrsa sign server $svrname 
			$WKDIR/easyrsa gen-dh 
			openvpn --genkey --secret ta.key 
			cp $WKDIR/ta.key $KEYS        
			cp $WKDIR/pki/dh.pem $KEYS 
			cp $WKDIR/pki/issued/$svrname.crt $KEYS 
			cp $WKDIR/pki/private/$svrname.key $KEYS 
			;; 
		"Client") 
			echo -e "Type your CLIENT(S) unique name: " 
			read clientname 
			echo -e "Building Client Certificate.." 
			$WKDIR/easyrsa gen-req $clientname nopass 
			$WKDIR/easyrsa sign client $clientname 
			cp $WKDIR/pki/issued/$clientname.crt $KEYS 
			cp $WKDIR/pki/private/$clientname.key $KEYS 
			;; 
		"Gen-Pem")
			echo -e "Type your conf: "
			read confname
			echo -e "compiling rsa"
			openssl rsa -in $KEYS/$confname.key -out $KEYS/$confname.pem
			;; 
		"Quit") 
			break 
			;; 
		*) echo invalid option;; 
	esac 
done
