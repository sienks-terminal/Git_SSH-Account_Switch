#!/usr/bin/env zsh

function Echo_Color(){
    case $1 in
        r* | R* )
        COLOR='\033[0;31m'
        ;;
        g* | G* )
        COLOR='\033[0;32m'
        ;;
        y* | Y* )
        COLOR='\033[0;33m'
        ;;
        b* | B* )
        COLOR='\033[0;34m'
        ;;
        *)
        echo "$COLOR Wrong COLOR keyword!\033[0m" 
        ;;
        esac
        echo -e "$COLOR$2\033[0m"
    }

# zsh shell will respect XDG spec if it is set, not currently supported in bash
case $SHELL in
    *zsh )
    profile=${ZDOTDIR:-$HOME}/.zshrc
    logout_profile=${ZDOTDIR:-$HOME}/.zlogout
    ;;
    *bash )
    profile=~/.bashrc
    logout_profile=~/.bash_logout
    ;;
    * )
    Echo_Color r "Unknown shell, need to manually add config on your shell profile!!"
    profile='unknown'
    logout_profile='unknown'
    ;;
esac

# source git-acc.sh from the current directory, that is the directory the setup.sh script
# is run from 
gitacc_config="# git account switch
source $PWD/git-acc.sh"

#cp ./git-acc.sh ~/.git-acc

if [ "$profile" = "unknown" ]; then
    echo 'Paste the information down below to your profile:'
    Echo_Color y "$gitacc_config\n"
    
    #echo 'Paste the information down below to your profile:'
    #Echo_Color y "$(cat ./logout.script)\n"
else
    if [ "$(grep -xn "$gitacc_config" $profile)" != "" ]; then
        Echo_Color g "You have already added git-acc config in $profile !!\nOnly update your git-acc!"
    else
        printf "\n$gitacc_config\n" >> $profile
        #echo "$(cat ./logout.script)" >> $logout_profile
    fi
fi

# Check if XDG_DATA_HOME is set, otherwise use the default directory
GITACC_DIR="~"

if [ -n "$XDG_DATA_HOME" ]; then
    GITACC_DIR="$XDG_DATA_HOME"
fi

# Check if .gitacc exists
if [ ! -f "$GITACC_DIR/.gitacc" ]; then
    # Create .gitacc in the default directory
    touch "$GITACC_DIR/.gitacc"
fi

source $profile
echo "Done!! Now can use! Enjoy~~~"
