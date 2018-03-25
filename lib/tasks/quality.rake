require 'flog'
require 'flog_task'
require 'flay'
require 'flay_task'

FlogTask.new :flog, 30, %w[app lib], :max_method, true
FlayTask.new :flay, 32, %w[app lib]


desc "Runs all code quality metrics"
task :quality => [:flay, :flog]
