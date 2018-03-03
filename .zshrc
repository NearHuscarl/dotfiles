# ============================================================================
# File:        .zshrc
# Description: zsh setting for interactive mode
# Author:      Near Huscarl <near.huscarl@gmail.com>
# Last Change: Fri Dec 29 18:34:07 +07 2017
# Licence:     BSD 3-Clause license
# Note:        N/A
# ============================================================================

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
setopt autocd extendedglob
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/near/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load custom environtment variables
[[ -f ~/script/bash/export ]] && . ~/script/bash/export

PROMPT='%F{blue}%n%f@%F{cyan}%m%f %F{magenta}%1~%f $ '

function zle-line-init zle-keymap-select {
    NORMAL_PROMPT="%F{blue} [% NORMAL]% %f"
    INSERT_PROMPT="%F{green} [% INSERT]% %f"

    RPS1="${${KEYMAP/vicmd/$NORMAL_PROMPT}/(main|viins)/$INSERT_PROMPT}"
    RPS2=$RPS1

    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Default is 0.4s delay when change from insert to normal mode, set to 0.1s
export KEYTIMEOUT=1

# set keymap vi-command
# "\eu": vi-redo

# vi key bindings
bindkey -v
# Insert mode
bindkey -M viins '\ei' vi-cmd-mode
bindkey -M viins '\en' menu-complete
bindkey -M viins '\ep' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete # fix Shift-TAB not working as expected
bindkey -M viins '\e9' backward-delete-word
bindkey -M viins '\e0' forward-delete-word
bindkey -M viins '\eh' vi-backward-char
bindkey -M viins '\ek' vi-up-line-or-history
bindkey -M viins '\el' vi-forward-char
bindkey -M viins '\ej' vi-down-line-or-history

# completion mode
zstyle ':completion:*' menu select
zmodload zsh/complist
# insert completion on first tab even if ambiguous
setopt menu_complete

# Enter once
bindkey -M menuselect '^M' .accept-line
# Enter twice: first to select autocomplete, second to execute
bindkey -M menuselect ' ' accept-search
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

#     _    _ _
#    / \  | (_) __ _ ___
#   / _ \ | | |/ _` / __|
#  / ___ \| | | (_| \__ \
# /_/   \_\_|_|\__,_|___/

# change directory {{{
alias dkt='cd $HOME/Desktop'
alias dot='cd $HOME/dotfiles'
alias cdh='cd $HOME'
alias cdw='cd $HOME/Github/NearHuscarl.github.io/'
alias cdp='cd $HOME/Github/LearnPythonTheHardWay/'
alias cd-pic='cd $HOME/Pictures'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# }}}
# list {{{
alias  ls="ls --color=auto"
alias  la="ls --color=auto -A"
alias  ll="ls --color=auto -oh"
alias lla="ls --color=auto -ohA"
alias  lr="ls --color=auto -R"
alias lss="ls -A    | grep --color=auto -i"
alias lls="ls -Aoh  | grep --color=auto -i"
alias lrs="ls -ARoh | grep --color=auto -i"
alias tree="alias-tree"
# }}}
# vim {{{
if [[ -x /usr/bin/vim ]]; then
   alias view="vim -R"
   alias vim0="vim -u NONE"
   alias vimrc="vim $HOME/.vimrc"
   alias vim-startup="vim --startuptime $HOME/misc/log -c q && vim $HOME/misc/log"
   # vir in $HOME/bin/vir
   if [[ -x $HOME/bin/viman ]]; then
      alias man="viman"
   fi
fi
# }}}
# NetworkManager {{{
if [[ -x /usr/bin/NetworkManager ]]; then
	# watch available wifi list
	# watch -n 0.5 -t 'nmcli dev wifi'
	
	# connect/disconnect wifi, example: nmcli dev connect wlo1
	alias nm-connect="alias-nm-connect"
	alias nm-disconnect="nmcli dev disconnect $(nmcli device status | awk '/wifi/ {print $1}')"
	alias nm-list="nmcli connection show"
	alias nm-delete="nmcli connection delete"
	alias nm-avail="nmcli dev wifi"
	alias nm-active="nmcli connection show --active"
	# info of active connection
	alias nm-info="nmcli connection show $(nmcli connection show --active | awk 'NR == 2 {print $1}')"
fi
# }}}
# pacman {{{
if [[ -x /usr/bin/pacman ]]; then
   alias pac-install="alias-pac-install"
   alias pac-update="alias-pac-update"
   alias pac-remove="sudo pacman -Rs"
   alias pac-search="pacman -Qsq"
   alias pac-Search="pacman -Ssq"
   alias pac-list="alias-pac-list"
   alias pac-orphan="sudo pacman -Rns $(pacman -Qtdq)"                                   # Remove unused packages (orphans)
   alias pac-info="pacman -Si"
   alias pac-desc="expac -S '%d'"
   alias pac-size="expac -S -HM '%k\t%n'"                                                # Show download size of package(s)
   alias pac-size-l="expac -S -HM '%k\t%n' | sort -n | tail -n"                          # Show nth largest download size of package(s)
   alias pac-latest="expac -HM --timefmt='%Y-%m-%d %T' '%l\t%-20n\t%m' | sort | tail -n" # List nth last installed packages
   alias pac-latest-e="alias-pac-latest-e"                                               # List nth last explicitly installed packages which is not in base/base-devel group
   alias pac-dep="alias-pac-dep"                                                         # Print package's dependencies

   # AUR
   if [[ -x /usr/bin/pacaur ]]; then
      alias aur-install="pacaur -Sa"
      alias aur-clean="pacaur -Sca"
      alias aur-update="pacaur -Syua"
      alias aur-remove="pacaur -Rsa"
      alias aur-search="pacaur -Qsqa"
      alias aur-Search="pacaur -Ssqa"
      alias aur-info="pacaur -Sia"
      alias aur-desc="alias-aur-desc"
      alias aur-size="alias-aur-size"
      alias aur-dep="alias-aur-dep"
   fi
fi
# }}}
# systemd {{{
if [[ -x /usr/bin/systemctl ]]; then
   alias sd-start="sudo systemctl start"
   alias sd-stop="sudo systemctl stop"
   alias sd-enable="sudo systemctl enable"
   alias sd-disable="sudo systemctl disable"
   alias sd-status="sudo systemctl status"
fi

if [[ -x /usr/bin/journalctl ]]; then
   alias sd-log="journalctl -b"
   alias sd-search="journalctl -b | grep"
   alias sd-clean="journalctl --vacuum-size=100M"
fi
# }}}
# git {{{
if [[ -x /usr/bin/git ]]; then
   alias gstat='git status'
   alias gadd='git add'
   alias gcommit="git commit"
   alias gCommit='git commit -a'
   alias gclone='git clone'
   alias glog='git log \
      --color \
      --graph \
      --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" \
      --abbrev-commit'
   alias glogstat='glog --stat'
   alias glogdiff='glog --stat -p'
   alias gschange='git log --patch -S'
   alias gscommit='git log --grep'
   alias gpull='git pull'
   alias gpush='git push'
   alias gfixcommit='git commit --amend'                     # Fix commit msg without altering its snapshot
   alias gfixstage='git commit --amend --reuse-message=HEAD' # Fix commit (staging other files)
   alias gunstage='git reset HEAD'
   alias grestore='git checkout --'
   alias gswitch='git checkout'
   alias gnewbranch='git checkout -b'
   alias gremove='git rm --cached'                           # Remove file in vcs while keeping in the local location
   alias gdelbranch='git branch -d'
   alias gdelremote='git push origin :'
   alias gmerge='git merge'

   # gdiff [num] where num is commit [num]nth
   if [[ -x /usr/bin/vim && -f $HOME/.vim/plugged/vim-fugitive/plugin/fugitive.vim ]]; then
      alias gdiff="alias-gdiff"
   else
      alias gdiff="alias-gdiff-old"
   fi
fi
# }}}
# trash-cli {{{
if [[ -x /usr/bin/trash-put ]]; then
   alias rm-hard="rm -I"
   alias rm="trash-put"
   alias rm-ls="trash-list"
   alias rm-ls-latest="trash-list | sort | tail -n"
   alias rm-search="trash-list | grep"
   alias rm-restore="trash-restore"
   alias rm-empty="trash-empty"
   alias rm-rm="trash-rm"
fi
# }}}
# Edit config file {{{
alias compton-conf="$editor $HOME/.config/compton.conf"
alias dunst-conf="$editor $HOME/.config/dunst/dunstrc"
alias i3-conf="$editor $HOME/.config/i3/config"
alias git-conf="$editor $HOME/.config/git/config"
alias neofetch-conf="$editor $HOME/.config/neofetch/config"
alias polybar-conf="$editor $HOME/.config/polybar/config"
alias dunst-conf="$editor $HOME/.config/dunst/dunstrc"
alias mp-conf="$editor $HOME/.config/ncmpcpp/config"

alias alias-e="$editor $HOME/bin/alias"
alias bashrc="$editor $HOME/.bashrc"
alias zshrc="$editor $HOME/.zshrc"
alias inputrc="$editor $HOME/.inputrc"
alias gitignore="$editor $HOME/.gitignore"
alias todo="i3-sensible-terminal -e 'vim --servername todo -c \"silent SessionOpen todo\"' --title=Todo"
alias plan="$editor $HOME/misc/plan"
alias arch="$editor $HOME/misc/Arch.txt"
# }}}
# xprop {{{
alias xprop-class="xprop WM_CLASS"
alias xprop-role="xprop WM_WINDOW_ROLE"
alias xprop-title="xprop _NET_WM_NAME WM_NAME"
# }}}
# Picture {{{
alias wallpaper='nitrogen --random --set-scaled "$HOME/Pictures/low_poly"'
alias pic-schedule="sxiv -f $HOME/Pictures/misc/schedule.png"
alias pic-full="sxiv -f"
alias thumnail="sxiv -f -t -b -r *"
alias pic="alias-pic"
alias sxiv="sxiv -b -s h"
# }}}
# Other {{{
alias sz='source $HOME/.zshrc && clear'
alias xmod='xmodmap ~/.Xmodmap'
alias reboot='shutdown -r now'
alias shutoff='$HOME/bin/shutdown'
alias size="alias-size"
alias size-l="alias-size-l"
alias mkdir='mkdir -pv'
alias top="vtop"
alias internet="$editor $HOME/misc/Internet.txt"
alias alsa-fix="sudo /usr/local/bin/fix_headphones_audio.sh"
alias music="ncmpcpp"
alias clock="tty-clock -s -c -D -C6"
alias symlink="ln -s"
alias fuck='fc -e "sed -i -e \"s/^/sudo /\""'
alias toggle-tray="alias-toggle-tray"
alias key-import='gpg --recv-keys'
# }}}
# Even shorter aliases {{{
alias r='fc -e "sed Q"'
alias e='exit'
alias c='clear'
alias js='node'
alias py='python'
# }}}
