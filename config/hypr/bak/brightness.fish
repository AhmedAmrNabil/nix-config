#!/usr/bin/env fish
echo 'ddcci 0x37' | sudo tee /sys/bus/i2c/devices/i2c-5/new_device
sleep 2s
waybar