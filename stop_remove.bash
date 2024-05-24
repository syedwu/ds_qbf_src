#! /bin/bash


# Stop all containers 

docker stop $(docker ps -q)

# Reomve all containers

docker rm $(docker ps -aq)

# docker rmi -f $(docker images -q)

