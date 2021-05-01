# Safe Alloy

+ Display a list of security local IP streams
+ Save them to `RECORD_DIRECTORY` in `INTERVAL_MINUTES` minutes
+ Delete oldest file in `RECORD_DIRECTORY` when disk usage gets to `DISK_USAGE_LIMIT`
+ Tested on Ubuntu 20.10
+ Compatible with ESP32-Cam devices

## Configuration

1. Install Ffmpeg; make sure it's on PATH;
1. Create a `.env` text file with the same settings found in `.env.example`;
1. Increse of decrese the number of sets of ffmpeg+ffplay+CAMX_PID+kill instructions on safe-alloy.sh script, according to how many cameras you have on your network.

## Run with

`./safe-allow.sh`
