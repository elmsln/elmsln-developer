ELMSLN Developer
================

This is a meta-repo for developers that downloads all the repositories you
need to be an ELMSLN developer and manage multiple learning networks from
one package.

This structure is broken out into three major directory trees:
1. *github* - the elmsln major project repository from github
    https://github.com/btopro/elmsln
2. *instances* - Each deployment of ELMSLN can be managed from this repo.
    It also comes with the following two instances:
    a. example config - https://github.com/btopro/elmsln-config-example
    b. vagrant config - https://github.com/btopro/elmsln-config-vagrant
3. *vagrant* - the supported vagrant package for elmsln
    https://github.com/btopro/elmsln-vagrant/

It is recommended that in your actual deployments on server that you map
the github directory to an alternate remote in-house, preferably one per
server in your dev-staging-production workflow.
