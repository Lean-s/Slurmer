# Regenerates the job history screenshots in images/.
#
# From the repository root:
#
#   cargo build --release
#   vhs scripts/screenshots/history.tape
#
# No Slurm cluster is needed: the scripts in scripts/screenshots/bin stand
# in for squeue, sinfo, sacctmgr and sacct and print fixed demo jobs.

# VHS always records a video too; keep it out of the repository
Output target/history.gif

Require python3

Set Shell "bash"
Set Theme "rose-pine-dawn"
Set FontSize 28
Set Width 3200
Set Height 2080
Set Padding 20
Set Margin 60
Set MarginFill "#000000"
Set WindowBar Colorful
Set WindowBarSize 80
Set BorderRadius 16

# slurmer filters on $USER, so pin it to the demo user
Env USER "weiwenjie"

Hide
Type "export USER=weiwenjie PATH=$PWD/scripts/screenshots/bin:$PATH PS1='$ ' && clear" Enter
Type "./target/release/slurmer" Enter
Sleep 2s
Show

# Job history, most recently finished first
Type "h"
Sleep 1s
Screenshot images/history.png

# Sorted by CPU use, worst first. VHS's terminal sometimes fails to repaint
# the top of the popup after a re-sort, so close and reopen the view (the
# sort is kept) to have it drawn from scratch.
Type "s"
Type "o"
Escape
Type "h"
Sleep 1s
Screenshot images/history-cpu.png

Hide
Escape
Escape
