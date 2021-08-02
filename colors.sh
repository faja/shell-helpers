#!/bin/bash -

# http://www.andrewnoske.com/wiki/Bash_-_adding_color

# tput setaf color # Set text color
# tput smul        # Start underline mode
# tput rmul        # Exit underline mode
# tput bold        # Set bold mode
# tput setab color # Set background color
# tput sgr0        # Reset all attributes

# colors
#   Black 0
#   Red 1
#   Green 2
#   Yellow 3
#   Blue 4
#   Magenta 5
#   Cyan 6
#   White 7


BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)
NORMAL=$(tput sgr0)
