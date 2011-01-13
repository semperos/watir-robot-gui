require 'fileutils'
require 'net/http'
require 'uri'
require 'zip/zip'

REMOTE_JRUBY_JAR = "http://jruby.org.s3.amazonaws.com/downloads/1.5.6/jruby-complete-1.5.6.jar"
REMOTE_RF_JAR = "http://robotframework.googlecode.com/files/robotframework-2.5.5.jar"
REMOTE_MIGLAYOUT_JAR = "http://www.migcalendar.com/miglayout/versions/3.7.3.1/miglayout-3.7.3.1-swing.jar"
PROJECT_HOME = File.expand_path(File.dirname(__FILE__))
YARDOC_CACHE = File.join(PROJECT_HOME, 'lib/ruby/watir_robot_yardoc')
COMMON_RESOURCES = Dir.glob(File.join(PROJECT_HOME, 'resources/common/*'))

namespace :retrieve do
  desc "Retrieve jruby-complete.jar from Github downloads (custom build)"
  task :jruby_complete do
    uri = URI.parse(REMOTE_JRUBY_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(PROJECT_HOME,"lib/standalone/jruby-complete.jar"), "wb") do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve Robot Framework from Google Code"
  task :robotframework do
    uri = URI.parse(REMOTE_RF_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(PROJECT_HOME,"lib/standalone/robotframework.jar"), "wb") do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve MigLayout from its home site"
  task :miglayout do
    uri = URI.parse(REMOTE_MIGLAYOUT_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(PROJECT_HOME,"lib/java/miglayout.jar"), "wb") do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve jar dependencies from various locations"
  task :jars do
    Rake::Task['clean:jars'].invoke
    java_jar_dir = File.join(PROJECT_HOME, 'lib/java')
	standalone_jar_dir = File.join(PROJECT_HOME, 'lib/standalone')
    FileUtils.mkdir_p(jar_dir) unless File.exists?(jar_dir)
	FileUtils.mkdir_p(standalone_jar_dir) unless File.exists?(standalone_jar_dir)
    
    puts "Please wait, downloading jars. This could take a while..."
    Rake::Task['retrieve:jruby_complete'].invoke
    if File.exists?(File.join(PROJECT_HOME, 'lib/standalone/jruby-complete.jar'))
      puts "Jar 'jruby-complete.jar' added successfully."
    else
      raise(StandardError, "Jar 'jruby-complete.jar' could not be added.")
    end

    Rake::Task['retrieve:robotframework'].invoke
    if File.exists?(File.join(PROJECT_HOME, 'lib/standalone/robotframework.jar'))
      puts "Jar 'robotframework.jar' added successfully."
    else
      raise(StandardError, "Jar 'robotframework.jar' could not be added.")
    end

    Rake::Task['retrieve:miglayout'].invoke
    if File.exists?(File.join(PROJECT_HOME, 'lib/java/miglayout.jar'))
      puts "Jar 'miglayout.jar' added successfully."
    else
      raise(StandardError, "Jar 'miglayout.jar' could not be added.")
    end
  end

  desc "Generate yardoc file from Watir Robot submodule and move into resources folder"
  task :yardoc do
    raise(StandardError, "You must run 'git submodule init' and/or 'git submodule update' to retrieve Watir Robot's code in order to generate the yardoc.") unless
      File.exists?(File.join(PROJECT_HOME, 'submodules/watir-robot/.git'))

    Rake::Task['clean:yardoc'].invoke
    FileUtils.cd(File.join(PROJECT_HOME, 'submodules/watir-robot'))
    system("yardoc")
    FileUtils.cd(PROJECT_HOME)
    original_file = File.join(PROJECT_HOME, 'submodules/watir-robot/.yardoc')
    FileUtils.mv(original_file, YARDOC_CACHE)
  end

  desc "Pull down all dependencies"
  task :all do
    puts "Retrieving jar dependencies..."
    Rake::Task['retrieve:jars']
    puts "Retrieving yardoc cache..."
    Rake::Task['retrieve:yardoc']
    puts "Complete. All dependencies are satisfied."
  end

end

namespace :clean do

  desc "Clean out dependency jars"
  task :jars do
    Dir.glob(File.join(PROJECT_HOME, 'lib/java/*.jar')).each do |f|
      FileUtils.rm(f)
    end
	Dir.glob(File.join(PROJECT_HOME, 'lib/standalone/*.jar')).each do |f|
      FileUtils.rm(f)
	end
  end

  desc "Delete yardoc cache from resources folder"
  task :yardoc do
    FileUtils.rm_rf(YARDOC_CACHE) if File.exists?(YARDOC_CACHE)
  end

  desc "Delete generated zip files"
  task :zips do
    Dir.glob(File.join(PROJECT_HOME, 'package/**/*.zip')).each do |f|
      FileUtils.rm(f)
    end
  end

end

namespace :zip do

  desc "Zip up the dist directory with jar and friends"
  task :dist do
    FileUtils.cd(File.join(PROJECT_HOME, 'package'))
    # Here there will be platform-specific folders ready for zippage
    zip_file = 'watir-robot-gui.zip'
    Zip::ZipFile.open(zip_file, true) do |zf|
      Dir.glob('watir-robot-gui/**/*').each do |f|
        zf.add(f, f)
      end
    end
  end

end
