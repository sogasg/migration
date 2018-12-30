#!/bin/bash

set -e
source .env

# prune arc build
echo "Pruning Arc build..."
npm run prune-arc-build -- "$@"
# migrate ganache
echo "Migrating ganache..."
npm run migrate -- "$@"
# migrate kovan
echo "Migrating kovan..."
npm run migrate -- --gasPrice 10 --provider $kovan_provider --private-key $kovan_private_key "$@"
# migrate rinkeby
echo "Migrating rinkeby..."
npm run migrate -- --gasPrice 10 --provider $rinkeby_provider --private-key $rinkeby_private_key "$@"
# set version
echo "Setting version..."
node set-version.js
# commit addresses
echo "Commiting changes..."
git add -A && git commit -m "release $(cat package.json | jq -r '.version')"
# push to git
echo "Pushing to github..."
git push -f
# done
echo "Done!"
