# ~/.zshrc — loads modular config from ~/.zsh/
# Order matters: exports -> plugins (loads Oh My Zsh) -> aliases -> functions
ZSH_CONFIG_DIR="$HOME/.zsh"

for file in exports plugins aliases functions; do
  source "$ZSH_CONFIG_DIR/$file.zsh"
done
