#!/bin/bash

# This script correctly sets the PYTHONPATH so that hg can invoke nvr as it's
# editor

PYTHONPATH="/home/adurg/.local/lib/python3.6/site-packages/" nvr -cc vsp --remote-wait $1
