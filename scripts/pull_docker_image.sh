#! /bin/bash

registry_url="172.16.31.2:5000"


if [ $# -ne 1 ];then
    progname=$(basename $0)
    echo "Usage:"
    echo ""
    echo "$progname <image_name>[:<tag>]"
    echo ""
    echo "this command will automatically help you pull"
    echo "docker images from $(echo $registry_url | awk -F ":" '{print$1}')"
    exit 1
fi

image=$(echo "$1" | awk -F ":" '{print$1}')
tag=$(echo "$1" | awk -F ":" '{print$2}')

# if tag does not exist, use latest default
if [ -z "$tag" ];then
    echo "no tag specified, use \"latest\" default"
    tag="default"
fi

pull_name=$registry_url"/"$image":"$tag
final_name=$image":"$tag


docker pull $pull_name
docker tag $pull_name $final_name
docker rmi $pull_name