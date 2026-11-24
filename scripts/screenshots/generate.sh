#!/bin/sh
# Regenerates the job history screenshots in images/.
#
# Needs VHS (https://github.com/charmbracelet/vhs), which brings ffmpeg, and
# Python 3 for the fake Slurm commands. No Slurm cluster is needed.
set -e
cd "$(dirname "$0")/../.."

cargo build --release
vhs scripts/screenshots/history.tape

# VHS paints the margin around the window black; make it transparent like
# the other screenshots, so it blends into whatever page shows the README
for png in images/history.png images/history-cpu.png; do
    ffmpeg -loglevel error -y -i "$png" -vf "colorkey=black:0.05:0.15,format=rgba" "$png.tmp.png"
    mv "$png.tmp.png" "$png"
done
