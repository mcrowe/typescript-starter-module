#!/usr/bin/env bash

function replace() {
  find package.json README.md -type f -exec sed -i "" "s/\[$1\]/$2/g" {} +
}

echo "Enter your package name (kebab-case):"
read name
echo "Enter a description for your package:"
read description
echo "Create a new github repository? (yes/no):"
read repo

echo "Updating package.json and README.md"
replace "PACKAGE_NAME" "$name"
replace "PACKAGE_DESCRIPTION" "$description"

echo "Removing template files"
rm TEMPLATE.md
rm bin/install.sh

echo "Re-initializing git repository"
rm -rf .git
git init
git add .
git commit -am 'Initial commit'

if [ "$repo" == "yes" ]
then
  echo "Creating new github repo"
  curl -u 'mcrowe' https://api.github.com/user/repos -d "{\"name\":\"$name\",\"description\":\"$description\"}"
  git remote add origin git@github.com:mcrowe/projectname.git
  git push origin master
fi