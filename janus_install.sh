#!/bin/bash

function janus_module () {
    url=$1
    re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)(.git)?$"
    if [[ $url =~ $re ]]; then
        protocol=${BASH_REMATCH[1]}
        separator=${BASH_REMATCH[2]}
        hostname=${BASH_REMATCH[3]}
        user=${BASH_REMATCH[4]}
        repo=${BASH_REMATCH[5]}
    fi
    echo "Checking Vim module ${repo}"
    mkdir -p ~/.janus
    cd ~/.janus
    if [ -d ~/.janus/${repo} ]
    then
        echo "Updating ${url} - ${repo}"
        cd ~/.janus/${repo}
        git pull
    else
        echo "Installing ${url} - ${repo}"
        git clone ${url} ${repo}
    fi
    echo ""
}

echo "Installing RPM dependencies"
yum -y install ruby rubygem-rake ruby-devel ctags ack git
echo ''

if [ -d ~/.vim ]
then
    echo "Updating Janus"
    cd ~/.vim
    rake
else
    echo "Installing Janus"
    curl -L https://bit.ly/janus-bootstrap | bash
fi
echo ''

echo "Updating ~/.vimrc.after"
cat /dev/null > ~/.vimrc.after
echo 'set bg=dark' >> ~/.vimrc.after
echo '"set t_co=256' >> ~/.vimrc.after
echo 'set tabstop=4' >> ~/.vimrc.after
echo 'set shiftwidth=4' >> ~/.vimrc.after
echo 'set expandtab' >> ~/.vimrc.after
echo 'colorscheme solarized' >> ~/.vimrc.after
echo ''

janus_module https://github.com/vim-scripts/ruby-matchit.git
janus_module https://github.com/tpope/vim-fugitive
janus_module https://github.com/tpope/vim-surround
janus_module https://github.com/scrooloose/nerdtree
janus_module https://github.com/airblade/vim-gitgutter
