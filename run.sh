#!/bin/bash -e
# Simplenote-to-git
# This backup solution is designed to allow you to back up your 
# Simplenote notes to a git repo.  This is completely compatible
# github's gist service.
#
# By default, this script does not delete notes.
#
# To start using this script, fill in settings.cfg with your
# Simplenote credentials and the URL of the repo you would like
# to back up to.

if [ ! "${0%/*}" = "${0}" ] ; then
    cd ${0%/*}
fi

source settings.cfg
if [ "$simplenote_username" = "" ] ; then
    echo "Your username is not set for SimpleNote in settings.cfg!"
    exit 1
fi
if [ "$simplenote_password" = "" ] ; then
    echo "Your password is not set for SimpleNote in settings.cfg!"
    exit 2
fi
if [ "$git_repo" = "" ] ; then
    echo "Please point to a git repo in settings.cfg."
    exit 3
fi
if [ "$git_branch" = "" ] ; then
    echo "Please configure which branch you would like to pull from."
    exit 4
fi


echo "Checking if the notes folder exists"
if [ ! -d notes ] ; then
    mkdir notes
fi

echo "Checking if there is currently a repo in the notes directory"
if [ -d notes/.git ]; then
    # This repo currently exists.
    cd notes
    git pull origin $git_branch --no-rebase
    cd ..
else
    # We need to check out this repo
    cd notes
    git init
    git remote add origin $git_repo
    git pull origin $git_branch --no-rebase
    cd ..
fi

echo "Updating the .gitignore"
touch .gitignore
cat .gitignore > notes/.gitignore
touch notes/.last_update

echo "Running the downloader script:"
if [ ! -d env ] ; then
    python3 -m venv env
fi
source env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python download.py "$simplenote_username" "$simplenote_password"

echo "Commit the changes to the remote repo"
cd notes
git add .
git commit -am "Changes update on $(date +%Y-%m-%d) at $(date +%H:%M)"
git push origin $git_branch

echo "Backup completed"
