#!/bin/env bash

# setup dotfiles

# setup vim
# mkdir github && git clone cd_fzf termite-color-switcher

# COLORS {{{
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"
# }}}
print_progress() { #{{{
	# Console width number
	T_COLS="$(tput cols)"
	echo -e " ${GREEN}> $1${RESET}\n" | fold -sw $(($T_COLS - 2))
}
# }}}
print_warning() { #{{{
	T_COLS="$(tput cols)"
	echo -e "  ${YELLOW}$1${RESET}\n" | fold -sw $(($T_COLS - 2))
}
# }}}

setup_repos() { # {{{
	local repos='fzf-everything termite-color-switcher arch_installer grub2-themes react-boilderplate'
	mkdir -pv "$HOME/github/"
	cd "$_"

	for repo in ${repos[@]}; do
		git clone "https://github.com/NearHuscarl/$repo"
	done
}
# }}}
setup_vim() { # {{{
	if [[ -e "$HOME/.vim/setup.sh" ]]; then
		print_progress 'Setup vim config files'
		"$HOME/.vim/setup.sh"
	else
		print_warning 'Vim setup file not found'
	fi
}
# }}}
setup_misc() { # {{{
	pip install --user nh-currency # for polybar crypto module
}
# }}}

main() { # {{{
	setup_repos
	setup_vim
	setup_misc
}
# }}}

main
