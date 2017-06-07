#!/bin/bash

# openssl genrsa -passout pass:dontChangeIt -aes256 -out ca-key.pem 4096
# openssl req \
# 	-new -x509 \
# 	-days 365 \
# 	-key ca-key.pem \
# 	-sha256 \
# 	-out ca.pem \
# 	-passin pass:dontChangeIt \
# 	-subj "/C=FR/ST=Denial/L=Springfield/O=Dis/CN=alien4cloud.org"

# Generate a keypair for the server, and sign it with the CA
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=alien4cloud.org" -sha256 -new -key server-key.pem -out server.csr
echo "subjectAltName=IP:10.0.0.1" > extfile.cnf 
echo "extendedKeyUsage=serverAuth" > extfile.cnf
openssl x509 -req -days 365 -sha256 \
	-in server.csr -CA ca.pem -CAkey ca-key.pem \
	-CAcreateserial -out server-cert.pem \
	-passin pass:dontChangeIt \
	-extfile extfile.cnf
