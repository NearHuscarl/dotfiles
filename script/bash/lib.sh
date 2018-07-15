#!/bin/env bash

# a list of utility functions

function gitroot() { # {{{
	git rev-parse --show-toplevel 2> /dev/null
}
# }}}
