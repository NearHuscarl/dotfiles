# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	if [[ ${EUID} == 0 ]] ; then
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
	fi
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi
unset color_prompt force_color_prompt

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if [ -x /usr/bin/mint-fortune ]; then
	/usr/bin/mint-fortune
fi

# Custom settings

# Export custom environment variables
[[ -f ~/bin/export ]] && . ~/bin/export

shopt -s autocd
shopt -s extglob

# +-----------------------+-----------------------+
# |    Regular Colors     |    High Intensity     |
# |-----------------------+-----------------------|
# | Black  | '\033[0;30m' | Black  | '\033[0;90m' |
# | Red    | '\033[0;31m' | Red    | '\033[0;91m' |
# | Green  | '\033[0;32m' | Green  | '\033[0;92m' |
# | Yellow | '\033[0;33m' | Yellow | '\033[0;93m' |
# | Blue   | '\033[0;34m' | Blue   | '\033[0;94m' |
# | Purple | '\033[0;35m' | Purple | '\033[0;95m' |
# | Cyan   | '\033[0;36m' | Cyan   | '\033[0;96m' |
# | White  | '\033[0;37m' | White  | '\033[0;97m' |
# | Reset  | '\033[0m'    |        |              |
# +-----------------------+-----------------------+

# {{{ prompt
#    [----blue----][\u[----cyan----] \h][---magenta--] [\W] \$[--reset--]
PS1='\[\033[0;34m\][\u\[\033[0;36m\] \h]\[\033[0;35m\] [\W] \$\[\033[0m\] '
#     [----cyan----][--reset--]
PS2=' \[\033[0;36m\]\[\033[0m\] '

#    * [-magenta][--------script-name--------][reset]:[--green-][linenum]
PS4='* \033[0;35m$(basename ${BASH_SOURCE[0]})\033[0m:\033[0;36m${LINENO}'
#      [--blue--][--------function-name--------][reset]:
PS4+=' \033[0;94m${FUNCNAME[0]:+${FUNCNAME[0]}()\033[0m }'

export PS1
export PS2
export PS4
# }}}

# FONT_AWESOME="$(fc-list | grep --perl-regexp '(font-awesome|fontawesome)')"

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

# run custom alias script in all session
source ~/script/bash/alias
source ~/script/bash/cd_fzf # cd only work in subshell

function fzf() {
	"$(which fzf)" \
		--no-mouse \
		--cycle \
		--bind=alt-k:up,alt-j:down,alt-h:backward-char,alt-l:forward-char \
		--bind=alt-n:backward-word,alt-m:forward-word,alt-e:jump \
		--bind=alt-d:kill-line,alt-i:abort,alt-t:toggle \
		--color=hl:"$THEME_HL2",hl+:"$THEME_HL",bg+:"$THEME_BG_ALT" \
		--color=info:"$THEME_MAIN",pointer:"$THEME_MAIN",marker:"$THEME_MAIN2" \
		--color=spinner:"$THEME_MAIN",border:"$THEME_MAIN" "$@"
}

export -f fzf

# start ssh-agent
eval `keychain --eval --quiet --agents ssh id_rsa`

# ranger
if [[ -x /usr/bin/ranger && -f ~/.config/ranger/rc.conf ]]; then
	export RANGER_LOAD_DEFAULT_RC=FALSE
fi

if [[ -x /usr/bin/rg ]]; then
	export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow \
		--glob "!undo/*"'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# mkvirtualenv rmvirtualenv workon ... commands to manage python virtualenv
source ~/bin/virtualenvwrapper_lazyload

# python interactive prompt
export PYTHONSTARTUP=~/.pythonrc.py

# custom completion
source ~/Github/termite-color-switcher/completion/bash
