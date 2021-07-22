#!/bin/bash

echo -e "\n--- Build a Custom JupyterLab Image"
mkdir -p /tmp/empty_build_context
docker buildx build \
    -t jupyterlab-custom \
    -f /vagrant/Dockerfile /tmp/empty_build_context
