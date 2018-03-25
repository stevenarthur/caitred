
task :default => [ 'rspec', 'spec:javascript', 'cucumber', 'rubocop' ]
task :fast => [ 'rspec', 'spec:javascript', 'rubocop' ]

desc 'Run rubocop'
task :rubocop do
  fail 'Rubcop failed' unless system('rubocop --rails')
end

desc 'Run rspec'
task :rspec do
  fail 'RSpec failed' unless system('rspec')
end
