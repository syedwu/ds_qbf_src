#! /bin/bash

export MODE=1 # 0 = Sequential, 1 = Parallel-2RTT, 2 = Parallel-1RTT
export UDPSIZE="1232" # "stock" = Standard DNS
export ALG0="ECDSA256" #"RSASHA256", "ECDSA256"
export ALG="FALCON512" # "FALCON512","DILITHIUM2", "SPHINCS+-SHA256-128S"
export BUILDDIR="$(pwd)/build"
export WORKINGDIR="$(pwd)"

cd $WORKINGDIR
if [[ $UDPSIZE == "stock" ]]; then
  python3 build_docker_compose.py --bypass --maxudp 1232 --alg $ALG <<<"Y"
else
  python3 build_docker_compose.py --maxudp $UDPSIZE --alg0 $ALG0 --alg $ALG --mode $MODE <<<"Y"
fi

cd $BUILDDIR
docker-compose down
docker-compose build
cd $WORKINGDIR

