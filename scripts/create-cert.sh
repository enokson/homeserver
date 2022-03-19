mkdir ~/homeserver
mkdir ~/homeserver/certs
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -config self-sign-cert.conf  \
  -keyout ~/homeserver/certs/selfsigned.key -out ~/homeserver/certs/selfsigned.crt