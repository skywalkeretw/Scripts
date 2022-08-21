#! /bin/bash

# Command to run that fixes the touchscreen input on a Lenovo MIIX 320 10ICR running Linux

echo "Fixing Touch Input"
xinput set-prop "FTSC1000:00 2808:1015" 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
