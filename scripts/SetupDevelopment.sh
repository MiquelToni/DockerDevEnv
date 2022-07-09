#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: SetupDevelopment.sh <template>"
    exit 1
fi

template=$1
dockerfile="$template.dev.dockerfile"

docker rmi $template
docker build \
  --tag $template \
  --file $dockerfile .

echo "This container will be removed on close"
echo "To create a persistent container use \"CreatePersistentContainer.sh $template <your-container-name>\""
docker run -it --rm -v $(pwd):/home/main/project/ $template
