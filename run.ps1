docker image build -t api-node api
docker image build -t tests-node tests

docker network create test-net
docker volume create pg-data

docker container run -d --name postgres --net test_network -p 5432:5432 --mount type=bind,source="$(Get-Location)"/database,target=/docker-entrypoint-initdb.d --mount source=pg-data,target=/var/lib/postgresql/data -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=secretpassword -e POSTGRES_DB=sample-db postgres:11.5-alpine

docker container run --name api --net test_network -p 3000:3000 -d api-node

timeout 10

docker container run --name api-test --net test_network -e BASE_URL="http://api:3000" test-node