#!/bin/bash

cd book/src/
ln -s ../../ch*.md .
cd ..
mdbook build
cd ..
cp -R book/output dist/

# optional to view the result
# mdbook serve
# or
# cd dist
# python -m http.server

