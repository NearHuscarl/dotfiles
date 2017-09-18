#!/bin/bash

# ============================================================================
# File:        completion-utils.sh
# Description: Extra completion functions for specific cases (command + flag)
# Author:      Near Huscarl <near.huscarl@gmail.com>
# Last Change: Tue Sep 12 09:32:59 +07 2017
# Licence:     BSD 3-Clause license
# Note:        N/A
# ============================================================================

completionPath="/usr/share/bash-completion/completions"

# /usr/share/bash-completion/completions/pacman
if [[ -f $completionPath/pacman ]]; then
   # pacman -S completion function
   _pacman_S() {
      local cur prev
      _get_comp_words_by_ref cur prev
      _pacman_pkg Slq
   }

   _pacman_Q() {
      local cur prev
      _get_comp_words_by_ref cur prev
      _pacman_pkg Qq
   }
fi

if [[ -f $completionPath/git ]]; then
   _git_branch_d() {
      __gitcomp_direct "$(__git_heads "" "$cur" " ")"
   }
   _git_log_S() {
      __git_complete_symbol
   }
fi
