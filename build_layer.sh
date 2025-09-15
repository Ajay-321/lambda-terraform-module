#!/bin/bash
set -e

LAYER_DIR="lambda/lambda_layer"

# Clean old build
rm -rf $LAYER_DIR/python
mkdir -p $LAYER_DIR/python

# Install dependencies into python folder
pip3 install -r $LAYER_DIR/requirements.txt -t $LAYER_DIR/python

# Zip everything inside the folder for layer packaging
cd $LAYER_DIR
zip -r layer.zip python
cd -
