#!/bin/sh

branch=`git branch`
if [ "$branch" = "master" ]; then
	git checkout master
fi

git fetch upstream master

if [ "$?" -ne "0" ]; then
	echo "unable to find upstream branch. Are you on a forked repository?"
	exit 1
fi

diff=`git diff upstream/master`

if [ ! -z "$diff" ]; then
	echo "Your branch differs from upstream/master. Please run 'git pull upstream master' before continuing."
	exit 1
fi

read -p "UNI: " uni
read -s -p "password: " uni_pass
echo "\n"

git remote remove dokku &>/dev/null

while true; do
	read -p "Do you wish to continue with deploy? Did you make sure that no one else is in the middle of a deploy?: " yn
	case $yn in
		[Yy]* ) git remote add dokku dokku@208.68.37.106:data-api && git push dokku master; break;;
		[Nn]* ) exit 1;;
		* ) echo 'Please enter Y or N';;
	esac
done

while true; do
	read -p "Does everything look right? Go to data.adicu.com to monitor: " yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) echo "Please revert the repository back to a previous version and rerun deploy"; break;;
		* ) echo 'Please enter Y or N';;
	esac
done

git remote remove dokku

echo "deploy finished"

