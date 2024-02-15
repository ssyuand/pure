#!/bin/bash
export PATH=/usr/local/bin:$PATH
export EDITOR=nvim
export LANG=en_US.UTF-8
export TERM=xterm-256color
export JAVA_HOME='/usr/lib/jvm/java-18-openjdk/' # need it to change version
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH:$HOME/bin
export FZF_DEFAULT_COMMAND='fd . / --type f --color=never --hidden --absolute-path'
export FZF_DEFAULT_OPTS='--multi +s --no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'
export HISTFILESIZE=-1                  # unlimited
export HISTSIZE=-1                      # unlimited
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_history
alias rm="trash-put"
alias ll='ls -al --color --group-directories-first'
alias ls='ls -a -t --color -h --group-directories-first'
alias v='nvim'
alias ip='ip --color=auto'
shopt -s autocd
shopt -s histappend # append to history, don't overwrite it
eval "$(zoxide init bash --cmd c --hook pwd)"
PS1='\[\e[0;31m\]\u\[\e[0;31m\]@\[\e[0;34m\]\H \[\e[0;32m\]\W \[\e[0m\]$ \[\e[0m\]'

# CTRL-R - Paste the selected command from history into the command line
if [[ "$-" =~ "i" ]]; then # Check if it is an interactive terminal
	bind -x '"\C-r": hist_fzf'
fi

hist_fzf() {
	history -r
	output=$(history | fzf --tac | sed -r 's/\[[^]]*\]//g' | sed -r 's/ *[0-9]*\*? *//')
	READLINE_LINE=${output#*$'\t'}
	READLINE_POINT=0x7fffffff
}
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	startx
fi
[[ -n "$TMUX" ]] && PROMPT_COMMAND='echo -n -e "\e]2;${PWD/${HOME}/~}\e\\"; history -a; history -r;'

# =============================================================================
# Hook configuration for zoxide.
# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
	PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi
