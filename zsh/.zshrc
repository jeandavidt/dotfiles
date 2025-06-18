# Install zinit if not installed
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing zinit…%f"
    command mkdir -p $HOME/.zinit
    command git clone https://github.com/zdharma-continuum/zinit $HOME/.zinit/bin
fi
source "$HOME/.zinit/bin/zinit.zsh"
# Homebrew setup - do this early
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Load completions properly
autoload -Uz compinit
compinit

# Install zoxide manually (don't rely on zinit for this)
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
else
    # If zoxide isn't installed, try to install it
    if command -v brew >/dev/null; then
        echo "Installing zoxide with Homebrew..."
        brew install zoxide
        eval "$(zoxide init zsh)"
    fi
fi
# Install the missing history plugin
zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search
# Fast syntax highlighting
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting
# Autosuggestions
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
# Completions
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions
# Key bindings after plugins are loaded
zinit ice wait lucid atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word
'
zinit light zdharma-continuum/null
# FZF
if command -v fzf >/dev/null; then
    # FZF already installed, just source the scripts
    if [[ -f ~/.fzf.zsh ]]; then
        source <(fzf --zsh)
    elif [[ -f "$BREW_PREFIX/opt/fzf/shell/completion.zsh" ]]; then
        source "$BREW_PREFIX/opt/fzf/shell/completion.zsh"
        source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
    fi
else
    # Install FZF with Homebrew if not present
    if command -v brew >/dev/null; then
        echo "Installing fzf with Homebrew..."
        brew install fzf
        $(brew --prefix)/opt/fzf/install --no-bash --no-fish --key-bindings --completion --no-update-rc
    fi
fi
# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top --style full'
# Bat setup (if installed)
if command -v bat >/dev/null; then
    alias cat='bat --paging=never'
else
    # Install bat with Homebrew if not present
    if command -v brew >/dev/null; then
        echo "Installing bat with Homebrew..."
        brew install bat
        alias cat='bat --paging=never'
    fi
fi
# Starship prompt
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    # Install starship with Homebrew if not present
    if command -v brew >/dev/null; then
        echo "Installing starship with Homebrew..."
        brew install starship
        eval "$(starship init zsh)"
    fi
fi
# Custom shell options
setopt auto_cd               # cd by typing directory name
setopt auto_pushd            # push directories on directory stack
setopt pushd_ignore_dups     # don't push duplicates on stack
# Set FZF options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Alisases
alias ls=eza
alias tree='eza --tree --level=3  --group-directories-first --classify'
alias cat=bat

obsi (){
	pushd '/Users/jeandavidt/JDT-personal-vault/00 - Inbox' > /dev/null
	NAME="note"
	DATE=$(date +"20%y-%m-%d")
	if [[ $1 == "" ]]
	then 
		NAME+=" - ${DATE}"
	else
		NAME=$1
	fi
	nvim "${NAME}.md"
	popd > /dev/null
}
export XDG_CONFIG_HOME="$HOME/.config"


dia() {
	pushd '/Users/jeandavidt/JDT-personal-vault/04 - Permanent writing/Diary' > /dev/null
	DATE=$(date +"20%y-%m-%d")
	nvim "${DATE}.md"
	popd > /dev/null
}

# WaterFRAME tool RML Mapper
export RML_MAPPER_PATH='/Users/jeandavidt/.local/bin/rmlmapper-7.3.3-r374-all.jar'

