require'rake_n_bake'

@external_dependencies = %w[ruby]

task :default => [
  :"bake:check_external_dependencies",
  :"bake:code_quality:all",
  :"bake:rspec",
  :"bake:ok",
]
