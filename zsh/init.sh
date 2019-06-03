
## stack autocomplete
## https://docs.haskellstack.org/en/stable/shell_autocompletion/
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"
kb

