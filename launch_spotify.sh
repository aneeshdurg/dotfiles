#!/bin/bash
cd /home/aneesh/dotfiles/spotifywm/
LD_PRELOAD=spotifywm.so spotify &
disown %%
