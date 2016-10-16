#!/usr/bin/env bash
NEU='\033[0;35m' # Purple
POS='\033[0;32m' # Green
NEG='\033[0;31m' # Red
NC='\033[0m' # No Color

printf "\n${NEU}Updating package to latest preview release of BabylonJS${NC}\n\n"

VERSION=$(svn export https://github.com/BabylonJS/Babylon.js/trunk/dist/preview%20release . --force | grep -Eo "[0-9]+\.$" | sed "s/\.$//")

if [ -n ${VERSION+x} ]; then
  printf "\n${POS}Successfully downloaded preview release build $VERSION${NC}\n\n"

  printf "\n${NEU}Updating package.json version to $VERSION${NC}\n\n"
  sed -Ei.bak "s/\"version\": \"(.+)\..*\"/\"version\": \"\1.$VERSION\"/" package.json
  rm package.json.bak

  printf "\n${NEU}Creating a new commit and pushing to origin/master${NC}\n\n"
  git checkout master
  git pull
  git add -A
  git commit -m "Updated preview release to build $VERSION"
  git push

  if [ $? -eq 0 ]; then
    printf "\n${POS}Successfully updated package to preview release $VERSION!${NC}\n\n"
    exit 0
  else
    printf "\n${NEG}Failed to update, make sure you have sufficient git privilages!${NC}\n\n"
    exit 1
  fi

else
  printf "\n${NEG}Failed to download latest preview release${NC}\n\n"
  exit 1
fi