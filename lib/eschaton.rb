require "#{File.dirname(__FILE__)}/eschaton/eschaton"
require "#{File.dirname(__FILE__)}/eschaton/script_store"

# Require all files in eschaton
Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require file
end

# Require Translators
Dir["#{File.dirname(__FILE__)}/../translators/**/*.rb"].each do |file|
  Eschaton.dependencies.require file  
end

Eschaton::SliceLoader.load