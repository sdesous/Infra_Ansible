nano docker-compose.yml
mkdir -p data/nginx/
nano data/nginx/app.conf
sed -i 's/example.org/shadddesous.fr/g' data/nginx/app.conf
localhost:/volumes/letsencrypt_volume# mkdir -p /data/certbot/conf
localhost:/volumes/letsencrypt_volume# mkdir -p /data/certbot/www
localhost:/volumes/letsencrypt_volume# curl -L https://raw.githubusercontent.com/wmnnd/nginx-certbot/master/init-letsencrypt.sh > init-letsencrypt.sh
localhost:/volumes/letsencrypt_volume# chmod +x init-letsencrypt.sh 
localhost:/volumes/letsencrypt_volume# sed -i 's/docker/podman/g' init-letsencrypt.sh 

"/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"