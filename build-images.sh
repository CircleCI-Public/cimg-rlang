#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 4.1/Dockerfile -t cimg/rlang:4.1.3 -t cimg/rlang:4.1 .
docker build --file 4.2/Dockerfile -t cimg/rlang:4.2.0 -t cimg/rlang:4.2 .
