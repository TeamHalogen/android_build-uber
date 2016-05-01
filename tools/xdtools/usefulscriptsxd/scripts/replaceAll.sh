#!/bin/bash

echo "Replacing all occurences using regex '$2' in files matching '$1'"
find . -name "$1" -type f -print0 | xargs -0 sed -i "$2"
echo "Done"
