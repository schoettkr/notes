# Internet needs to be setup already
# Install yay
mkdir arch
cd arch
mkdir pkgs
cd ~
git clone https://aur.archlinux.org/yay.git ~/arch/pkgs 
cd arch/pkgs/yay
makepkg -si
cd ~

# Get dotfiles
yay -S stow
rm .config/user-dirs* # remove already present user-dirs config to avoid conflict
cd dotfiles # you need to be in the dotfiles directory
stow -v -t ~/.config config # with '-t' the target dir can be set explicitly
mkdir ~/.fonts
stow -v -t ~/.fonts fonts
stow -v git
stow -v scripts
rm ~/.xinitrc # to avoid conflict
stow -v X
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh # if not already installed
rm ~/.zshrc # to avoid conflict
stow -v zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
yay -S autojump --noconfirm
# Install dependencies for awesome
yay -S awesome-freedesktop lain --noconfirm
# Install some other stuff
yay -S redshift neofetch --noconfirm
