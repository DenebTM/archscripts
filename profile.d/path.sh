if [ -r $HOME/.profile ]; then
	. $HOME/.profile
fi
export PATH=$HOME/.local/bin:$PATH
