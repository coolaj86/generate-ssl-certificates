#!/bin/bash
set -e
set -u

# Change to be whatever
DEVICE_NAME="${1}"
FQDN="${2}"

# make directories to work from
mkdir -p certs/{devices,client,ca,tmp}

# Create Certificate for this domain,
openssl genrsa \
  -out certs/devices/${DEVICE_NAME}.key.pem \
  2048

# Create the CSR
openssl req -new \
  -key certs/devices/${DEVICE_NAME}.key.pem \
  -out certs/tmp/${DEVICE_NAME}.csr.pem \
  -subj "/C=US/ST=Utah/L=Provo/O=ACME Service/CN=${FQDN}"

# Sign the request from Device with your Root CA
openssl x509 \
  -req -in certs/tmp/${DEVICE_NAME}.csr.pem \
  -CA certs/ca/my-root-ca.crt.pem \
  -CAkey certs/ca/my-root-ca.key.pem \
  -CAcreateserial \
  -out certs/devices/${DEVICE_NAME}.crt.pem \
  -days 9131

# If you already have a serial file, you would use that (in place of CAcreateserial)
# -CAserial certs/ca/my-root-ca.srl
