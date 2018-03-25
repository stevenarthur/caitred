# Caitre'd 

## Getting started

1. Clone the repo, bundle 
2. Ensure postgres and redis are installed. Additionally, install direnv.
3. Get the passphrase for the encrypted (.envrc) secrets file. Get this from Paul. Un-encrypt with: `openssl aes-256-cbc -d -a -in .envrc.encrypted -out .envrc``
4. Run with `foreman start`
5. Access @ `http://localhost:5000`

## Importants / Things to know / Philosophies

* DONT ASSUME STAGING WILL NOT ACTION EMAILS ETC TO CUSTOMERS. THIS HAS NOT BEEN TESTED / CONFIRMED AS YET.
* If you make a change to the environment file, re-encrypt it with: `openssl aes-256-cbc -a -salt -in .envrc -out .envrc.encrypted`.
* Keep things as simple as possible wherever possible. Don't try and overcomplicate things and be smart if there is a simple workaround.
* Where possible, make extensive use of GitHub issues. If you see something that might be a bug; this is the place to report it.

## Images

* All the menu and partner images are stored in *Amazon S3*.
* One bucket for local and staging : **youchews-staging**
* One bucket for production : **youchews**

## Asynchron tasks

* All the asynchron and scheduled jobs are managed by *Sidekiq*.
* There is one worker on the production heroku environement and zero on the staging environement. 
