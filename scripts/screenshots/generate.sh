#!/bin/sh
# Regenerates the job history screenshots in images/.
#
# Needs VHS (https://github.com/charmbracelet/vhs), which brings ffmpeg, and
# Python 3 for the fake Slurm commands. No Slurm cluster is needed.
set -e
cd "$(dirname "$0")/../.."

cargo build --release
vhs scripts/screenshots/history.tape

# VHS records the bare window. Put it on a transparent canvas with a soft
# drop shadow, matching the existing screenshots (macOS window captures):
# a 3248x2112 canvas with the window at 112,76, and a shadow blurred by 48px,
# shifted 40px down, at 38% opacity, as measured from images/monitor.png.
for png in images/history.png images/history-cpu.png; do
    ffmpeg -loglevel error -y -i "$png" -frames:v 1 -filter_complex "
        [0:v]colorkey=black:0.05:0.15,format=rgba,split[window][shape];
        [shape]alphaextract,pad=3248:2112:112:116:black,gblur=sigma=48,lut=c0=val*0.38[shadow_alpha];
        color=black:s=3248x2112,format=rgba[black];
        [black][shadow_alpha]alphamerge[shadow];
        [shadow][window]overlay=112:76,format=rgba" "$png.tmp.png"
    mv "$png.tmp.png" "$png"
done
