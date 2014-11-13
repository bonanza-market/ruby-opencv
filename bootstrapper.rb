# When this gem is vendored and referenced by :path in the Gemfile, this module can be used to ensure that the 
# correct version of the native extension is built and installed, as well as checking that the version of OpenCV that
# ruby-opencv has been built against matches the expected version
# 
# e.g. in a rails application, with the gem vendored in vendor/gems/ruby-opencv, add this to application.rb:
#
#   require_relative '../vendor/gems/ruby-opencv/bootstrapper'
#   RubyOpenCVBootstrapper.bootstrap
#
# make sure to add these lines before the Bundler.require line that will (presumably) require ruby-opencv, but after
# boot.rb is required (so bundler/setup has been required by the time these lines are executed).
#
# Once ruby-opencv has been required, you can run the following to check that the version of opencv is what you expect
# it to be:

#   RubyOpenCVBootstrapper.check_opencv_version(...)
# 
module RubyOpenCVBootstrapper
  extend self
  
  def bootstrap
    gem_spec = Gem::Specification.find_by_name 'ruby-opencv'
    
    library_path = File.join(gem_spec.extension_dir, library_filename)
    if !File.exists?(library_path)
      puts "=> #{ library_filename } doesn't exist; building"
      build(gem_spec)
    else
      source_files = gem_spec.extensions + gem_spec.files.grep(/\.(cpp|c|h)\Z/)
      source_files.map! { |source_file| File.join(gem_spec.gem_dir, source_file) }
      
      unless FileUtils.uptodate?(library_path, source_files)
        puts "=> #{ library_filename } out of date; building"
        build(gem_spec)
      end
    end
  end
  
  def check_opencv_version(git_url, branch: 'master')
    extension_git_tag = OpenCV.build_information.scan(/Version control:\s+[\d\.]+\-(?:\d+\-)?(.+)\n/).flatten.first
    if extension_git_tag.blank?
      puts "=> Unable to determine version of OpenCV that #{ library_filename } was built against, skipping version check"
      return
    end
    
    remote_git_tag = `git ls-remote --heads #{ git_url } #{ branch }`.strip
    if remote_git_tag.blank?
      puts '=> Unable to determine remote OpenCV revision, skipping version check'
      return
    end
    remote_git_tag = remote_git_tag.first(8)

    if extension_git_tag != remote_git_tag
      puts "WARNING: ruby-opencv built against OpenCV tag #{ extension_git_tag } but latest OpenCV tag is #{ remote_git_tag }"
    end
  end
  
  private
  
  def build(gem_spec, debug: false)
    # Copied from Gem::Specification#build_extensions, with all the conditions that prevent the extension from being
    # built removed
    begin
      # We need to require things in $LOAD_PATH without looking for the
      # extension we are about to build.
      unresolved_deps = Gem::Specification.unresolved_deps.dup
      Gem::Specification.unresolved_deps.clear

      require 'rubygems/config_file'
      require 'rubygems/ext'
      require 'rubygems/user_interaction'

      Gem::DefaultUserInteraction.use_ui Gem::ConsoleUI.new do
        build_args = gem_spec.build_args
        build_args << '--enable-debug' if debug

        builder = Gem::Ext::Builder.new gem_spec, build_args
        builder.build_extensions
      end
    ensure
      Gem::Specification.unresolved_deps.replace unresolved_deps
    end
    
    puts "=> Copying #{ library_filename } to #{ gem_spec.extension_dir }"
    `cp #{ gem_spec.gem_dir }/lib/#{ library_filename } #{ gem_spec.extension_dir }/#{ library_filename }`
  end
  
  def library_filename
    if RUBY_PLATFORM =~ /darwin|mac os/
      'opencv.bundle'
    else
      'opencv.so'
    end
  end
end