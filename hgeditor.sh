#!/bin/bash

# This script correctly sets the PYTHONPATH so that hg can invoke nvr as it's
# editor
export PYTHONPATH="/usr/lib/python36.zip:/usr/lib/python3.6:/usr/lib/python3.6/lib-dynload:/home/adurg/.local/lib/python3.6/site-packages:/usr/local/lib/python3.6/dist-packages:/usr/lib/python3/dist-packages"
nvr -cc vsp --remote-wait $1
