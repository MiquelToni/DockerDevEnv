#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: CreatePersistentContainer.sh <template> <container-name>"
    exit 1
fi

template=$1
name=$2

docker run -it -v $(pwd):/home/main/project/ --name $name $template
