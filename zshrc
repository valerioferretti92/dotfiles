# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi 

bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down

# The following lines were added by compinstall
eval "$(dircolors)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/stacksmasher/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
SAVEHIST=10000
HISTSIZE=10000
setopt BANG_HIST
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
bindkey -e
# End of lines configured by zsh-newuser-install

if [[ -n $DISPLAY ]];
then
	source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
	[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else 
	source ~/.asciigit.zsh
fi

# ZSH syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ZSH substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=

# Aliases
alias ls='lsd --no-symlink --icon never'
alias ll='lsd --no-symlink -la --icon never'
alias l='lsd --no-symlink -la --icon never'
alias yay='yay --color=always'
alias screenshot='/home/stacksmasher/.config/qtile/scripts/screenshot.sh'

