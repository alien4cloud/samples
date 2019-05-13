#!/bin/bash -e

IP=$1
KEYSTORE_PWD=$2

SSL_DIR=`mktemp -d`
CN=alient4cloud.org
CA_PASSPHRASE=dontChangeIt
NAME=server

echo "Generate CA key"
openssl genrsa -passout pass:$CA_PASSPHRASE -aes256 -out $SSL_DIR/ca-key.pem 4096
echo "Generate CA certificate"
openssl req \
	-new -x509 \
	-days 365 \
	-key $SSL_DIR/ca-key.pem \
	-sha256 \
	-out $SSL_DIR/ca.pem \
	-passin pass:$CA_PASSPHRASE \
	-subj "/C=FR/ST=Denial/L=Springfield/O=Dis/CN=alien4cloud.org"

# echo "Generate client key"
# Generate a key pair
echo "Generate a key pair for $NAME"
openssl genrsa -out ${SSL_DIR}/${NAME}-key.pem 4096

echo "Generate a certificate for $NAME"
openssl req -subj "/CN=${CN}" -sha256 -new \
		-key $SSL_DIR/${NAME}-key.pem \
		-out $SSL_DIR/${NAME}.csr

# Sign the key with the CA and create a certificate
echo "[ ssl_client ]" > $SSL_DIR/extfile.cnf
echo "extendedKeyUsage=serverAuth,clientAuth" >> $SSL_DIR/extfile.cnf
if [ "${IP}" ]; then
	sudo echo "subjectAltName = IP:${IP}" >> $SSL_DIR/extfile.cnf
fi
echo "Sign the key with the CA and create a certificate for $NAME"
openssl x509 -req -days 365 -sha256 \
    -in $SSL_DIR/${NAME}.csr -CA $SSL_DIR/ca.pem -CAkey $SSL_DIR/ca-key.pem \
    -CAcreateserial -out $SSL_DIR/${NAME}-cert.pem \
    -passin pass:$CA_PASSPHRASE \
    -extfile $SSL_DIR/extfile.cnf -extensions ssl_client

# poulate key store
# echo "Generate client keystore using openssl"
echo "Generate client keystore using openssl"
openssl pkcs12 -export -name ${NAME} \
		-in $SSL_DIR/${NAME}-cert.pem -inkey $SSL_DIR/${NAME}-key.pem \
		-out $SSL_DIR/${NAME}-keystore.p12 -chain \
		-CAfile $SSL_DIR/ca.pem -caname root \
		-password pass:$KEYSTORE_PWD

echo "Generated key store in : $SSL_DIR/${NAME}-keystore.p12"
