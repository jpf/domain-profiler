require 'rake'
# Commenting out this next line will fix the stupid "undefined method `gem' for main:Object" error on debian systems ಠ_ಠ
gem "rspec", "~>1.3.0"
require 'spec/rake/spectask'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_files = FileList['spec/']
  t.rcov = true
  t.rcov_opts = lambda do
    IO.readlines("spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
  end
end
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/']
  t.spec_opts << '--options' << 'spec/spec.opts'
end

desc "Run all tests with RCov"
Spec::Rake::SpecTask.new('tests_with_rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

desc "Generate common files."
task :dump_main_lists do
  Site = Struct.new(:list, :header, :output)
  [
    Site.new('ycombinator-list-all', 'Y Combinator', 'ycombinator'),
    Site.new('500startups-list', '500 Startups', '500-startups'),
    Site.new('github-list', 'Github', 'github'),
    Site.new('list/quantcast-top-100', 'Quantcast Top 100', 'quantcast'),
  ].each do |site|
    puts " --- #{site.inspect}"
    Kernel.system "./profile-list #{site.list} '#{site.header}' > #{site.output}.html"
  end
end
