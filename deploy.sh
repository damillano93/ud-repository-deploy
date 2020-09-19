red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo "${green}------ INIT DEPLOY UD REPOSITORY ------${reset}"
cd compose-postgres
echo "${green}------ INIT DATABASE ------${reset}"
docker-compose up -d
echo "${green}------ INIT TRAEFIK ------${reset}"
cd ..
cd traefik
docker-compose up -d
cd ..
sleep 5
echo "${green}------ INIT CREATE DATABASES ------${reset}"
docker exec -it postgres-ud-repository psql -U postgres -c \
"CREATE DATABASE filesms;"
docker exec -it postgres-ud-repository psql -U postgres -c \
"CREATE DATABASE usersms;"
echo "${green}------ FINISH CREATE DATABASES ------${reset}"
sleep 5

echo "${green}------ CLONE ud-repository-files-ms ------${reset}"
git clone https://github.com/damillano93/ud-repository-files-ms
echo "${green}------ PASS environment ud-repository-files-ms ------${reset}"
cp envs/.ud-repository-files-ms-env ud-repository-files-ms/.env
cd ud-repository-files-ms && docker-compose up -d 
cd ..

echo "${green}------ CLONE ud-repository-users-ms ------${reset}"
git clone https://github.com/damillano93/ud-repository-users-ms
echo "${green}------ PASS environment ud-repository-users-ms ------${reset}"
cp envs/.ud-repository-users-ms-env ud-repository-users-ms/.env
cd ud-repository-users-ms && docker-compose up -d 
cd ..
sleep 5
echo "${green}------ CLONE ud-repository-api-ms ------${reset}"
git clone https://github.com/damillano93/ud-repository-api
echo "${green}------ PASS environment ud-repository-api ------${reset}"
cp envs/.ud-repository-api-env ud-repository-api/.env
cd ud-repository-api && docker-compose up -d 
cd ..

echo "${green}------ FINISH DEPLOY UD REPOSITORY ------${reset}"
