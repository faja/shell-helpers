#!/bin/sh -

set -e
set -o pipefail

KUBE_TMUX_PATH=/home/mc/GitRepos/OTHER/kube-tmux/kube.tmux
SESSION=$(tmux display-message -p '#S')
tmux set-option -t $SESSION status-right-length 140
tmux set-option -t $SESSION status-right "'#(/bin/bash ${KUBE_TMUX_PATH} 250 red cyan) #[fg=white] - %A %d.%B.%Y'"
