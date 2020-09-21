#!/bin/sh -

set -e
set -o pipefail

tmux display-message -p '#S'
