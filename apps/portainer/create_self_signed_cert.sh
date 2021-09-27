openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout ./certs/selfsigned.key -out ./selfsigned.crt