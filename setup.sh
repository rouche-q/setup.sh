#!/bin/bash

echo -e "Choose the OS to setup:"
echo -e "\t 1 - Ubuntu"
echo -e "\t 2 - MacOS"

read -p "Enter your choice [1]:" os
os=${os:-1}

case $os in
1)
	echo "--You chose Ubuntu--"

	echo "--Install zsh, ripgrep and other build packages"
	sudo apt update -y &&
		sudo apt install curl git zsh ninja-build gettext cmake unzip ripgrep g++ -y

	echo "--Install Neovim--"
	git clone https://github.com/neovim/neovim &&
		cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo &&
		sudo make install &&
		cd ..

	echo "--Install Golang--"
	wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz &&
		echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.zshrc

	echo "--Install Node--"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&
		nvm install node &&
		nvm use node
	;;
2)
	echo "--You chose MacOS--"
	echo "--Install Homebrew--"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	echo "--Install Iterm2--"
	brew install --cask iterm2

	echo "--Install Neovim, Ripgrep Go and Node--"
	brew install neovim ripgrep go node
	;;
esac

echo "--Install Ohmyzsh--"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "--Install Starship--"
curl -sS https://starship.rs/install.sh | sh &&
	echo 'eval "$(starship init zsh)"' >>~/.zshrc

echo "--Install LazyVim--"
git clone https://github.com/LazyVim/starter ~/.config/nvim &&
	rm -rf ~/.config/nvim/.git &&
	cp ./lazy-plugins/* .config/nvim/lua/plugins/
