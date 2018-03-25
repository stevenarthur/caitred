#!/bin/bash
source ~/.bashrc

# Exits bash immediately if any command fails
set -e

# Will output commands as the run
set -x

# Want to know what ENV varibles Buildbox sets during the build?
env | grep BUILDBOX

# Buildbox will run your builds by default in:
# ~/.buildbox/account-name/project-name
# pwd

# You can remove this conditional once you've added a repository
if [ -z "$BUILDBOX_REPO" ]; then
  echo "Congratulations! You just ran a build! Now it's time to fill out this build script and customize your project"
  exit 0
fi

# Here are some basic setup instructions for checkout out a git repository.
# You have to manage checking out and updating the repo yourself.

# If the git repo doesn't exist in the b
if [ ! -d ".git" ]; then
  git clone "$BUILDBOX_REPO" . -q
fi

# Always start with a clean repo
git clean -fd

# Fetch the latest commits from origin, and checkout to the commit being tested
git fetch -q
git checkout -qf "$BUILDBOX_COMMIT"

# Here are some basic instructions on how to run tests on a Ruby on Rails project
# with rspec. You can change these commands to be what ever you like.
#cp /home/ultima/ultima.env /home/ultima/.buildbox/ultima/paul/ultima-io/.env

#bundle install --path /home/paul/rubygems/

openssl aes-256-cbc -salt -a -d -in .rbenv-vars.encrypted -out .rbenv-vars -k  "$JEPSEN_ENCRYPTION_KEY"

bundle install

echo '--- preparing database'
./bin/rake db:create 
./bin/rake db:structure:load
./bin/rake db:migrate

echo '--- running specs'
./bin/spring stop
bundle exec rspec .

# Want to do continious delivery? It's easy to only run commands on a paticular branch.
# Here
if [ "$BUILDBOX_BRANCH" != "master" ]
then
  echo "Skipping deploy for the $BUILDBOX_BRANCH branch."
  exit 0
fi
