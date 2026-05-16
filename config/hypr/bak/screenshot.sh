#!/usr/bin/env bash
grim -g "$(slurp -b '#00000050' -d -F 'Jetbrains Mono' -w 2 -c '#74c7ec')" - | wl-copy
