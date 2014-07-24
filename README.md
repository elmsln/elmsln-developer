ELMSLN Developer
================

This is a meta-repo for developers that downloads all the repositories you
need to be an ELMSLN developer and manage multiple learning networks from
one package.

###Here’s what you need ahead of time to make this useful
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (ensure you are on the latest version 4.0.8+)
2. Install [Vagrant](http://www.vagrantup.com/downloads.html) (you'll need Vagrant 1.5+ so that it supports VagrantCloud)
3. Install [git](http://git-scm.com/downloads) (recommended)

To clone this correctly, run the following command:

`git clone --recursive https://github.com/btopro/elmsln-developer.git`

This structure is broken out into three major directory trees:

1. *github* - the elmsln major project repository from github
  * https://github.com/btopro/elmsln

2.  *instances* - Each deployment of ELMSLN can be managed from this repo:
   It also comes with the following two instances:
  * example config - https://github.com/btopro/elmsln-config-example
  * vagrant config - https://github.com/btopro/elmsln-config-vagrant

3. *vagrant* - the supported vagrant package for elmsln
  * https://github.com/btopro/elmsln-vagrant/

Now go read the install instructions for https://github.com/btopro/elmsln-vagrant/ and make sure things are setup to do that and start working :)

It is recommended that in your actual deployments on server that you map
the github directory to an alternate remote in-house, preferably one per
server in your dev-staging-production workflow.
