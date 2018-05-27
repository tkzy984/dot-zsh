#!/bin/zsh
# =========================================================
# users generic .zshrc file for zsh(1)
# =========================================================
# echo "start loading zshrc..."

# =========================================================
# Environment variable configuration
# =========================================================

# zmodload zsh/zprof && zprof

case $(uname -s) in
	Darwin)
		export PATH_TO_ZSH_D="${HOME}/.zsh.d"
		;;
	FreeBSD)
		export PATH_TO_ZSH_D="${HOME}/.zsh.d"
		# export PATH_TO_ZSH_D="/etc/zsh.d"
		;;
esac

source ${PATH_TO_ZSH_D}/init.zsh


## ========================================================
## The other setting
## ========================================================

## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

## Completion configuration
#
# compinit -u

## compile config file
#
case $(uname -s) in
	FreeBSD)
        [ /etc/zshrc -nt /etc/zshrc.zwc ] && zcompile /etc/zshrc
	    ;;
	Darwin)
	    [ ~/.zshrc -nt ~/.zshrc.zwc ] && zcompile ~/.zshrc
	    ;;
esac

# echo "Finished loading zshrc successfully!"

# if (which zprof > /dev/null) ;then
# 	zprof | less
# fi
