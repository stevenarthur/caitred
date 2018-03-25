#!/bin/sh
bin/rake db:drop
heroku pg:pull HEROKU_POSTGRESQL_MAUVE youchews_development --app youchews
#s3cmd --acl-public --access_key=${S3_KEY_ID} --secret_key=${S3_SECRET_KEY} --skip-existing sync s3://youchews s3://youchews-staging
