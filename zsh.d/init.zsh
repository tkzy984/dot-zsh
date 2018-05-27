#!/bin/zsh -eu
## ========================================================
## init.zsh -
## ========================================================

autoload -Uz catch
autoload -Uz throw
autoload -Uz compinit

source ${PATH_TO_ZSH_D}/public/antigen/antigen.zsh
#
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions
# antigen bundle marzocchi/zsh-notify


## ========================================================
## Functions
## ========================================================

## ========================================================================
## set-keymap - Public zsh function
## ========================================================================
SetKeyMap()
{
	## Keybind configuration
	#
	# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
	# to end of it)
	#
	bindkey -e
	bindkey "^[[1~" beginning-of-line # Home gets to line head
	bindkey "^[[4~" end-of-line # End gets to line end
	bindkey "^[[3~" delete-char # Del

	# historical backward/forward search with linehead string binded to ^P/^N
	#
	autoload history-search-end
	zle -N history-beginning-search-backward-end history-search-end
	zle -N history-beginning-search-forward-end history-search-end
	# bindkey "^p" history-beginning-search-backward-end
	# bindkey "^n" history-beginning-search-forward-end
	bindkey -M emacs '^P' history-substring-search-up
	bindkey -M emacs '^N' history-substring-search-down
	bindkey "\\ep" history-beginning-search-backward-end
	bindkey "\\en" history-beginning-search-forward-end

	# reverse menu completion binded to Shift-Tab
	bindkey "\e[Z" reverse-menu-complete
}


## ========================================================
## enable-advanced-command-history - Public zsh function
## ========================================================
EnableAdvancedCommandHistory()
{
	case ${1:-YES} in
		YES)
			## Command history configuration
			#
			HISTFILE=~/.zsh_history
			HISTSIZE=100000
			SAVEHIST=100000
			setopt hist_ignore_dups # ignore duplication command history list
			setopt share_history # share command history data
			;;
		NO)
			[ -f ~/.zsh_temp_history ] && rm ~/.zsh_temp_history
			HISTFILE=~/.zsh_temp_history
			HISTSIZE=100
			SAVEHIST=100
			setopt hist_ignore_dups # ignore duplication command history list
			;;
		*)
			echo "this function takes YES or NO as argument."
	esac

	zstyle ':completion:*' ignore-parents parent pwd ../
}


## ========================================================
## set-appearance-color - Public zsh function
## ========================================================
SetAppearanceColor()
{
	case "${TERM}" in
		xterm|xterm-color|xterm-256color) # expected terminal with black bgcolor
			export LSCOLORS=Cxfxcxdxbxegedabagacad
			export LS_COLORS='di=01;37:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
			zstyle ':completion:*' list-colors \
				   'di=01;37;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
			;;
		kterm-color)
			stty erase '^H'
			export LSCOLORS=exfxcxdxbxegedabagacad
			export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
			zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
			;;
		kterm)
			stty erase '^H'
			;;
		cons25)
			unset LANG
			export LSCOLORS=ExFxCxdxBxegedabagacad
			export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
			zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
			;;
		jfbterm-color)
			export LSCOLORS=gxFxCxdxBxegedabagacad
			export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
			zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
			;;
	esac

}


## ==========================================================
# set-history-substring-search
# @param string $1 prompt style - YES, NO
## ==========================================================
SetHistorySubstringSearch()
{
	case "$1" in
		"YES")
			bindkey -M emacs '^p' history-substring-search-up
			bindkey -M emacs '^n' history-substring-search-down
			;;
		"NO")
			bindkey "^p" history-beginning-search-backward-end
			bindkey "^n" history-beginning-search-forward-end
			;;
		*)
			echo "This function takes argument YES or NO only."
			;;
	esac
}


## ========================================================
## enable-code-completion - Public zsh function
## ========================================================
EnableCodeCompletion()
{
	fpath=(${PATH_TO_ZSH_D}/public-repos/zsh-completions/src(N-/) ${fpath})
	export BASH_COMPLETION_DIR=/usr/local/etc/bash_completion.d

	[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
	export AUTOJUMP_IGNORE_CASE=1
}


## ==========================================================
# set-prompt-style - Public zsh function
# @param string $1 prompt style - powerline, normal, doubleline
## ==========================================================
SetPromptStyle()
{
    ## =======================================================================
    ## Functions
    ## =======================================================================
    _InstallPowerlinePrecmd()
    {
        ##
        ## _install_powerline_precmd - Private zsh function
        ##
	    function powerline_precmd() {
		    ## mode options flat patched compatible
		    PROMPT="$(${PATH_TO_ZSH_D}/public-repos/powerline-shell/powerline-shell.py $? --mode patched --shell zsh 2> /dev/null)"
	    }

	    for s in "${precmd_functions[@]}" ; do
		    if [ "$s" = "powerline_precmd" ] ; then
			    return
		    fi
	    done
	    precmd_functions+=(powerline_precmd)
    }


    _InstallDoublelinePrompt()
    {
        ##
        ## _install-doubleline-prompt zsh function (Private)
        ##
	    function precmd() {
		    local pwd="`pwd`"
		    if [ ${pwd} = "`cat ~/.curdir`" ]
		    then
			    print "`termcol fg cyan`Current Directory >${PWD}`termcol reset`"
		    else
			    print "`termcol fg cyan`Went to Directory >${PWD}`termcol reset`"
		    fi
		    echo ${pwd} > ~/.curdir
	    }
    }


    ## =======================================================================
    ## Sub routine
    ## =======================================================================
	precmd_functions=( ${precmd_functions:#powerline*} )

	if [ "dumb" = ${TERM} -o "emacs" = ${TERM} ]; then
		throw "EmacsViaTramp"
	fi

	autoload -Uz colors
	colors
	case ${UID} in
		0) # root
			PROMPT="%B%{${fg[white]}%}[%~]#%{${reset_color}%}%b "
			PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
			;;
		*) # user
			PROMPT="%B%{${fg[green]}%}%%%{${reset_color}%}%b "
			PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
			SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
			RPROMPT=
			;;
	esac

    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    	PROMPT="%{${fg[red]}%}${USER}@${HOST%%.*}${PROMPT}"

	case ${1:-normal} in
		"powerline")
			RPROMPT="%{${fg[white]}%}[%~]%{${reset_color}%}"
			_InstallPowerlinePrecmd || echo "<zshrc loading...> loading powerline failed"
			;;
		"doubleline")
			_InstallDoublelinePrompt
			;;
        ##		"normal")
        ##			case ${UID} in
        ##				0)
        ##					PROMPT="%B%{${fg[white]}%}[%~]#%{${reset_color}%}%b "
        ##					;;
        ##				*)
        ##					PROMPT="%B%{${fg[white]}%}[%~]%%%{${reset_color}%}%b "
        ##					;;
        ##			esac
        ##			[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        ##				PROMPT="%{${fg[red]}%}${USER}@${HOST%%.*}${PROMPT}"
        ##			;;
		*)
			echo "option is powerline, normal or doubleline."
			;;
	esac
}


# =============================================
# Main routine
# =============================================

fpath=(${PATH_TO_ZSH_D}/kzbin(N-/) ${fpath})

## set terminal title including current directory
#
case "${TERM}" in
    xterm|xterm-color|xterm-256color|kterm|kterm-color)
 		precmd() {
			echo -ne "\033]0;${USER}@${HOST%%.*}\007"
 		}
 		;;
esac


# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd
setopt pushd_ignore_dups

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep


## zsh editor
#
# autoload -Uz zed

## Prediction configuration
#
##autoload predict-on
##predict-off


# ========================================================================
# Shortcut
#
# expand aliases before completing
# ========================================================================
autoload -Uz compinit; compinit -u
setopt complete_aliases

case "$(uname -s)" in
	FreeBSD|Darwin)
		alias ls="ls -G -w"
		;;
	Linux)
		alias ls="ls --color"
		;;
esac

alias where="command -v" jb="jobs -l" grep="grep -i --color=auto"

alias la="ls -a" lf="ls -F" ll="ls -l" lla="ls -al"

alias du="du -h" df="df -h" su="su -l"

alias h="history"
compdef h="history"

alias vi="vim" vim="vim" view="vim -R"

alias ff="find_file" ft="find_text" fd="find_dir"

alias ifcnf="ifconfig"

alias vag="vagrant"

alias mk='make'

# Git command
alias g="git" gbr="git branch" gs="git status"
compdef g=git

# Git log
alias gl="git log --relative-date"
# alias gl1="git log --oneline"
alias gl1='git log --pretty=format:"%C(red)%h %C(green)%an %ar %Creset%s%Creset" -10'
#alias glg="git log --graph"
alias glg='git log --graph --name-status --pretty=format:"%C(red)%h %C(green)%an %ar %Creset%s %C(yellow)%d%Creset"'
alias glg1="gl1 --graph"

alias -s git="git clone"


SetKeyMap
EnableAdvancedCommandHistory YES
SetAppearanceColor
SetHistorySubstringSearch NO
# EnableCodeCompletion
SetPromptStyle normal

[ "${PATH_TO_ZSH_D}/init.zsh" -nt "${PATH_TO_ZSH_D}/init.zsh.zwc" ] && zcompile "${PATH_TO_ZSH_D}/init.zsh"
