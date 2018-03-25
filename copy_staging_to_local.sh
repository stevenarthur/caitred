#!/bin/sh
bin/rake db:drop
heroku pg:pull DATABASE youchews_development --app staging-youchews
