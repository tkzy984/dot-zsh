#!/bin/zsh
## zshenv for macOS


#
# Browser
#

if [[ "$(uname -s)" == Darwin ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vi'
export VISUAL='vi'
export PAGER='less'

#
# Language
#

case ${UID} in
    0) export LANG=C
	   ;;
	*) export LANG=en_US.UTF-8
	   ;;
esac

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

ccache_path=(
	/usr/bin
	/usr/local/bin
)


case $(uname -s) in
	Darwin)
        export HOMEBREW_CASK_OPTS="--appdir=/Applications"

        export XDG_CONFIG_HOME=$HOME/.config

        # export SYS_NOTIFIER="/Users/kei/.rbenv/shims/terminal-notifier"
        export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10

        LESS='-gj10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
        LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

        fpath=(${PATH_TO_ZSH_D}/bin-osx(N-/) ${fpath})

        autoload -Uz wiki
        autoload -Uz dict
        autoload -Uz google

        alias op='open'

        autoload -Uz extract
        alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
		;;
	FreeBSD)
        alias checkupdates='portsnap fetch update; sudo pkg update; sudo pkg version -v -l \<'
		;;
esac


#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
export LESSOPEN='| /opt/local/bin/src-hilite-lesspipe.sh %s'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
# if (( $#commands[(i)lesspipe(|.sh)] )); then
#   export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
# fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

## basic path
path=(
	/usr/local/{bin,sbin}(N-/) # for homebrew
	/opt/local/{bin,sbin}(N-/) # for macports
	/usr/bin(N-/)
	/bin(N-/)
	/usr/sbin(N-/)
	/sbin(N-/)
	/usr/X11/bin(N-/)
	${HOME}/.kbin(N-/)
	${HOME}/bin(N-/)
	${path}
)


manpath=(
	/usr/local/opt/gnu-sed/libexec/gnuman(N-/)
	${manpath}
)
