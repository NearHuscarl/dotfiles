#!/bin/bash

# Launch python script in its proper virtual environment
cd $(dirname $0)
source "$WORKON_HOME"/polybar_module/bin/activate

./weather.py "$@"
