#!/usr/bin/env bash

set -e

cp $(pwd)/m1/settings.xml ~/.m2/settings.xml
rm -rf ~/.doom.d && ln -s $(pwd)/doom.d ~/.doom.d && doom sync
