require 'simplecov'

lib = File.expand_path('.')
$:.unshift(lib) unless $:.include?(lib)

Dir["./spec/support/**/*.rb"].sort.each do |f|
  require f
end

SimpleCov.start
require 'chatbot'
