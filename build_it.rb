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
  cmd = "make #{target}"
	puts "Running #{cmd}..."
  `#{cmd} 2>&1`
end
