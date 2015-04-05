require'rake_rack'

@external_dependencies = %w[ruby mpg321]

task :default => [
  :"rake_rack:check_external_dependencies",
  :"rake_rack:code_quality:all",
  :"rake_rack:rspec",
  :"rake_rack:ok",
]
