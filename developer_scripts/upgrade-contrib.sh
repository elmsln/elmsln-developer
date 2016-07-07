#!/bin/bash
# this script automates much of the garbage of checking and getting new modules
# ELMS:LN has reached such a scale that it's time consuming to even get projects
# via drush. This goes through and tries to get updated versions of, everything.
#
# where am i? move to where I am. This ensures source is properly sourced
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
# location of elmsln on their local development system
elmsln="${DIR}/../system"
#provide messaging colors for output to console
txtbld=$(tput bold)             # Bold
bldgrn=${txtbld}$(tput setaf 2) #  green
bldred=${txtbld}$(tput setaf 1) #  red
txtreset=$(tput sgr0)
dev='-dev'
elmslnecho(){
  echo "${bldgrn}$1${txtreset}"
}
elmslnwarn(){
  echo "${bldred}$1${txtreset}"
}
timestamp(){
  date +"%s"
}

# test for an argument as to what user to write as
if [ -z $1 ]; then
  elmslnwarn "Are you sure you want to do this? It kicks off quite a bit (type yes)"
  read confirm
else
  confirm=$1
fi

# make sure they said yes
if [ $confirm == "y" ] || [ $confirm == "yes" ]; then
  cd $elmsln
  # make git branch
  branch="automated-upgrade-$(timestamp)"
  git checkout -b $branch
  # push branch so it exists
  git push origin $branch
  elmslnecho "working on the shared contrib ulmus directory"
  # move into ulmus directory for contrib projects
  cd "${elmsln}/core/dslmcode/shared/drupal-7.x/modules/ulmus/"
  for modulename in `ls` ; do
    version=$(cat $(ls ${modulename}/*.info) | grep version | sed 's/version//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g')
    if [ "${version/$dev}" = "$version" ] ; then
        drush dl ${modulename} --default-major=7 --y
      else
        drush dl ${modulename}-7.x --y
    fi
    # test for patches being removed
    removed="$(git status | grep '.patch')"
    if [ "${removed}" == '' ]; then
      git add -A
      git commit -m "${modulename} module upgrade"
      git push origin $branch
    else
      elmslnwarn 'patches deleted detected, please add this manually!'
      patched+=("${elmsln}/core/dslmcode/shared/drupal-7.x/modules/ulmus/${modulename}")
      git reset --hard origin/$branch
    fi
  done
  elmslnecho "now time to work through each stack's contrib modules"
  # now work in each stack's local contrib directory
  cd "${elmsln}/core/dslmcode/stacks"
  for stack in `ls` ; do
    if [ -d "${stack}/sites/all/modules/local_contrib" ]; then
      elmslnecho "working on ${stack}"
      cd "${stack}/sites/all/modules/local_contrib"
      for modulename in `ls` ; do
        version=$(cat $(ls ${modulename}/*.info) | grep version | sed 's/version//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g')
        if [ "${version/$dev}" = "$version" ] ; then
            drush dl ${modulename} --default-major=7 --y
          else
            drush dl ${modulename}-7.x --y
        fi
        # test for patches being removed
        removed="$(git status | grep '.patch')"
        if [ "${removed}" == '' ]; then
          git add -A
          git commit -m "${modulename} module upgrade"
          git push origin $branch
        else
          elmslnwarn 'patches deleted detected, please add this manually!'
          patched+=("${stack}/sites/all/modules/local_contrib/${modulename}")
          git reset --hard origin/$branch
        fi
      done
    fi
    # step back to where we were
    cd "${elmsln}/core/dslmcode/stacks"
  done
  # tell user they need to do these manually, bleh
  elmslnwarn "You need to manually upgrade the following"
  for patch in $patched ; do
    elmslnwarn $patch
  done
  # switch back to master
  git checkout master
  elmslnecho "All done! Go here to check out what travis says: https://github.com/elmsln/elmsln/tree/${branch}"
fi
