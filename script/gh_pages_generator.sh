#!/bin/bash

##
# Based on the blog post at http://www.aymerick.com/2014/07/22/jekyll-github-pages-bower-bootstrap.html
##

echo "Please enter the github repository url ( git@github.com:<user>/<repo>.git ): "
read GIT_REPO

BASENAME=$(basename $GIT_REPO)
DIR_NAME=${BASENAME%%.*}

# Set up new jekyll site and sync with github repo
jekyll new $DIR_NAME
cd $DIR_NAME
git init
git add -A
git commit -m 'initial commit.  Add jekyll site'
git remote add origin $GIT_REPO
git fetch
git branch --set-upstream-to=origin/master master
git pull
git push

# Set up gh-pages branch
git checkout --orphan gh-pages
git reset .
rm -r *
rm .gitignore
echo 'Coming soon' > index.html
git add index.html
git commit -m 'Initializing gh-pages orphan branch'
git push -u origin gh-pages

# Checkout the gh-pages
git checkout master
git clone $GIT_REPO -b gh-pages _site