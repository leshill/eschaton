require 'rake'
require 'yard'
require 'rake/testtask'
require 'rake/rdoctask'
require 'code_statistics'
  
# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../config/environment'

desc 'Default: run eschaton tests.'
task :default => :test

desc 'Test the eschaton plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc "Report code statistics (KLOCs, etc) from the eschaton and slices"
task :stats do
  STATS_DIRECTORIES = [
    %w(eschaton           lib/eschaton),
    %w(kernel_slice       slices/eschaton_kernel),
    %w(google_maps_slice  slices/google_maps),
    %w(jquery_slice       slices/jquery)
  ].collect { |name, dir| [ name, "#{File.dirname(__FILE__)}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }  
  
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end

def clear_docs
  FileUtils.rm_rf("doc")
end

desc 'Generate YARD documentation for the eschaton plugin.'
YARD::Rake::YardocTask.new(:ydoc) do |t|
  clear_docs
  
  t.files = ['lib/**/*.rb', "slices/*/**/*.rb"]
  t.options = ['-r', 'README.rdoc', '-d', 'doc']  
end

desc 'Generate documentation for the eschaton plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  clear_docs
    
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'eschaton'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.main = "README.rdoc"

  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include("slices/*/**/*.rb")
end

desc 'Opens documentation for the eschaton plugin.'
task :open_doc do |rdoc|
  `open doc/index.html`
end

desc 'Default: run eschaton tests.'
task :rdoc_and_open => [:rdoc, :open_doc]

desc 'Updates eschaton related javascript files.'
task :update_javascript do
  update_javascript
end

desc 'Clones an eschaton slice from a git repo'
task :clone_slice do
  Eschaton::SliceCloner.clone :repo => ENV['slice']
end

def update_javascript
  project_dir = RAILS_ROOT + '/public/javascripts/'
  scripts = Dir['generators/map/templates/*.js']

  FileUtils.cp scripts, project_dir

  puts 'Updated javascripts:'
  scripts.each do |script|
    puts "  /public/javascripts/#{File.basename(script)}"
  end  
end