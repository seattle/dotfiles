#!/bin/bash

NOW=`date +%Y-%m-%d.%H:%M:%S`
BACKUP_DIR="dotfiles-backup.$NOW.$$"
CURRENT_DIR=`pwd`

## Backup existing configuration
FILES=".bash_profile .profile .bashrc .gitconfig .gitignore .ackrc .zlogin .zshrc .tmux.conf .htoprc .gemrc .rvmrc"
pushd ~ > /dev/null 2>&1
mkdir $BACKUP_DIR
mv -f $FILES $BACKUP_DIR 2> /dev/null
popd > /dev/null 2>&1
echo "Current configuration has been backed up to $BACKUP_DIR"

## Copy new configuration
# dotfiles
DOTFILES="profile bashrc gitconfig gitignore ackrc zlogin zshrc tmux.conf htoprc gemrc rvmrc"
for F in $DOTFILES
do
    \cp $F ~/.$F
done
ln -s ~/.profile ~/.bash_profile


# custom scripts
mkdir -p ~/bin
\cp bin/* ~/bin/

## git postinstall stuff
# editor
git config --global core.editor "vim"
git config --global core.excludesfile ~/.gitignore
# github token
if [[ -f ~/.github_token ]]; then
    TOKEN=`cat ~/.github_token`
    git config --global github.token $TOKEN
fi
# bash completion for Git
read -p "Download bash completion file for Git (y/n)? "
[ "$REPLY" == "y" ] && curl -s https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

echo "All done!"
exit 0
