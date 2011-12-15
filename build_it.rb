# This script will install the native extension locally in a bundler-compatible way
# without one having to check in -> push -> bundle update constantly.
#
# When you run this, it will compile the extension, then copy the result it into the lib directory
# like a good gem.
#
# The only other thing you need to do is manually declare this gem to be the gem's local directory
# in the Gemfile of your Rails project.

require 'ruby-debug'

puts "Building extconf..."
`#{Gem.ruby} ./extconf.rb`

# Co-opting builder.rb from bundler
dest_path = ::File.expand_path('lib/',  File.dirname(__FILE__))
mf = File.read('Makefile')
mf = mf.gsub(/^RUBYARCHDIR\s*=\s*\$[^$]*/, "RUBYARCHDIR = #{dest_path}")
mf = mf.gsub(/^RUBYLIBDIR\s*=\s*\$[^$]*/, "RUBYLIBDIR = #{dest_path}")

File.open('Makefile', 'wb') {|f| f.print mf}
['', ' install'].each do |target|
  cmd = "ruby extconf.rb && make #{target}"
	puts "Running #{cmd}..."
  `#{cmd} 2>&1`
end
