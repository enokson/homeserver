openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout ./apps/nginx/certs/selfsigned.key -out ./apps/nginx/certs/selfsigned.crt