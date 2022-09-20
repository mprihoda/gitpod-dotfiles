#!/usr/bin/env bash

set -e

S=$(dirname $0)

cp -r "${S}"/m2 /home/gitpod/.m2

if [ -e /home/gitpod/.doom.d ]
then
	        rm -rf /home/gitpod/.doom.d
fi

ln -s "${S}"/doom.d /home/gitpod/.doom.d && doom sync
