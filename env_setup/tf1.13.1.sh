#! /bin/bash
if command conda > /dev/null 2>&1
then
	curl -o anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
	bash anaconda.sh -b
fi

conda create -n py36 python=3.6