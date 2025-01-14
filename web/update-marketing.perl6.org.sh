#!/bin/bash
. /home/marketing/perl5/perlbrew/etc/bashrc
set -e -x
echo 'Starting marketing.perl6.org update'
date
cd ~/marketing/web/

git fetch
before=$(git rev-parse HEAD)
git checkout origin/master
after=$(git rev-parse HEAD)
cp update-marketing.perl6.org.sh ../../
cp start-marketing.perl6.org.sh  ../../

if [ "$before" != "$after" ]
then
    echo "Got new commits"
    if [[ `git log "$before"..."$after" --oneline` =~ '[REAPP]' ]]; then
        echo "Restarting app"
        set +e
        hypnotoad app.pl
        set -e
    fi
fi

echo 'Done'
