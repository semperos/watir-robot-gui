require 'fileutils'
require 'net/http'
require 'uri'
require 'zip/zip'

REMOTE_JRUBY_JAR = "http://jruby.org.s3.amazonaws.com/downloads/1.5.6/jruby-complete-1.5.6.jar"
REMOTE_RF_JAR = "http://robotframework.googlecode.com/files/robotframework-2.5.5.jar"
REMOTE_MIGLAYOUT_JAR = "http://www.migcalendar.com/miglayout/versions/3.7.3.1/miglayout-3.7.3.1-swing.jar"

PROJECT_HOME = File.expand_path(File.dirname(__FILE__))
LIB_DIR = File.join(PROJECT_HOME, 'lib')
SRC_DIR = File.join(PROJECT_HOME, 'src')
SUBMODULE_DIR = File.join(PROJECT_HOME, 'submodules')
RESOURCE_DIR = File.join(PROJECT_HOME, 'resources')
JAVA_JAR_DIR = File.join(PROJECT_HOME, 'lib/java')
STANDALONE_JAR_DIR = File.join(PROJECT_HOME, 'lib/standalone')
RUBY_DEP_DIR = File.join(PROJECT_HOME, 'lib/ruby')
YARDOC_CACHE = File.join(RUBY_DEP_DIR, 'watir_robot_yardoc')

PACKAGE_DIR = File.join(PROJECT_HOME, 'package')
WIN_PACKAGE_DIR = File.join(PACKAGE_DIR, 'windows')
OSX_PACKAGE_DIR = File.join(PACKAGE_DIR, 'osx')
NIX_PACKAGE_DIR = File.join(PACKAGE_DIR, 'nix')

# COMMON_RESOURCES = Dir.glob(File.join(PROJECT_HOME, 'resources/common/*'))

namespace :clean do

  desc "Clean out dependency jars"
  task :jars do
    Dir.glob(File.join(JAVA_JAR_DIR, '*.jar')).each do |f|
      FileUtils.rm(f)
    end
	Dir.glob(File.join(STANDALONE_JAR_DIR, '*.jar')).each do |f|
      FileUtils.rm(f)
	end
  end

  desc "Delete yardoc cache from resources folder"
  task :yardoc do
    FileUtils.rm_rf(YARDOC_CACHE) if File.exists?(YARDOC_CACHE)
  end

  desc "Delete generated zip files"
  task :zips do
    Dir.glob(File.join(PACKAGE_DIR, '**/*.zip')).each do |f|
      FileUtils.rm(f)
    end
  end
end

namespace :package do
  desc "Setup for packing common across platforms"
  task :setup do
    # Clean and create directories
	FileUtils.rm_rf(PACKAGE_DIR) if File.exists? PACKAGE_DIR
	[WIN_PACKAGE_DIR, OSX_PACKAGE_DIR, NIX_PACKAGE_DIR].each do |d|
		FileUtils.mkdir_p(d) unless File.exists? d
		
		# Copy over component parts
		FileUtils.cp_r(SRC_DIR, d)
		FileUtils.cp_r(LIB_DIR, d)
		
		# Create resources dir and move *.png icon in
		FileUtils.mkdir_p(File.join(d, 'resources')) unless
		  File.exists? File.join(d, 'resources')
		FileUtils.cp(File.join(RESOURCE_DIR, 'watir_robot_icon.png'),
		  File.join(d, 'resources/watir_robot_icon.png')
	end
  end
  
  desc "Package Windows version of Watir Robot GUI"
  task :windows do
    # Setup batch file
	FileUtils.cp(File.join(RESOURCE_DIR, 'setup.bat'), WIN_PACKAGE_DIR)
	
	# TODO: VBS files for making shorcuts to Desktop
	
	# Start batch file
	FileUtils.cp(File.join(RESOURCE_DIR, 'start.bat'), WIN_PACKAGE_DIR)
	
	# Windows-format icon
	FileUtils.cp(File.join(RESOURCE_DIR, 'watir_robot_gui.ico'), File.join(WIN_PACKAGE_DIR, 'resources/watir_robot_gui.ico'))
  end
  
  desc "Package Mac OSX version of Watir Robot GUI"
  task :osx do
    # Setup shell file
	FileUtils.cp(File.join(RESOURCE_DIR, 'setup.sh'), OSX_PACKAGE_DIR)
	
	# Start shell file
	FileUtils.cp(File.join(RESOURCE_DIR, 'start.sh'), OSX_PACKAGE_DIR)
	
	# Windows-format icon
	FileUtils.cp(File.join(RESOURCE_DIR, 'watir_robot_gui.icns'), File.join(OSX_PACKAGE_DIR, 'resources/watir_robot_gui.icns'))
  end
  
  desc "Package *nix version of Watir Robot GUI"
  task :nix do
    # Setup shell file
	FileUtils.cp(File.join(RESOURCE_DIR, 'setup.sh'), NIX_PACKAGE_DIR)
	
	# Start shell file
	FileUtils.cp(File.join(RESOURCE_DIR, 'start.sh'), NIX_PACKAGE_DIR)
  end

namespace :retrieve do
  desc "Retrieve jruby-complete.jar from Github downloads (custom build)"
  task :jruby_complete do
    uri = URI.parse(REMOTE_JRUBY_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(STANDALONE_JAR_DIR, 'jruby-complete.jar'), 'wb') do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve Robot Framework from Google Code"
  task :robotframework do
    uri = URI.parse(REMOTE_RF_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(STANDALONE_JAR_DIR, 'lib/standalone/robotframework.jar'), 'wb') do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve MigLayout from its home site"
  task :miglayout do
    uri = URI.parse(REMOTE_MIGLAYOUT_JAR)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)

    open(File.join(JAVA_JAR_DIR, 'miglayout.jar'), 'wb') do |file|
      file.write(resp.body)
    end
  end

  desc "Retrieve jar dependencies from various locations"
  task :jars do
    Rake::Task['clean:jars'].invoke
    FileUtils.mkdir_p(JAVA_JAR_DIR) unless File.exists?(JAVA_JAR_DIR)
	FileUtils.mkdir_p(STANDALONE_JAR_DIR) unless File.exists?(STANDALONE_JAR_DIR)
    
    puts "Please wait, downloading jars. This could take a while..."
    Rake::Task['retrieve:jruby_complete'].invoke
    if File.exists?(File.join(STANDALONE_JAR_DIR, 'jruby-complete.jar'))
      puts "Jar 'jruby-complete.jar' added successfully."
    else
      raise(StandardError, "Jar 'jruby-complete.jar' could not be added.")
    end

    Rake::Task['retrieve:robotframework'].invoke
    if File.exists?(File.join(STANDALONE_JAR_DIR, 'robotframework.jar'))
      puts "Jar 'robotframework.jar' added successfully."
    else
      raise(StandardError, "Jar 'robotframework.jar' could not be added.")
    end

    Rake::Task['retrieve:miglayout'].invoke
    if File.exists?(File.join(JAVA_JAR_DIR, 'miglayout.jar'))
      puts "Jar 'miglayout.jar' added successfully."
    else
      raise(StandardError, "Jar 'miglayout.jar' could not be added.")
    end
  end

  desc "Generate yardoc file from Watir Robot submodule and move into resources folder"
  task :yardoc do
    raise(StandardError, "You must run 'git submodule init' and/or 'git submodule update' to retrieve Watir Robot's code in order to generate the yardoc.") unless
      File.exists?(File.join(SUBMODULE_DIR, 'watir-robot/.git'))

    Rake::Task['clean:yardoc'].invoke
    FileUtils.cd(File.join(SUBMODULE_DIR, 'watir-robot'))
    system("yardoc")
    FileUtils.cd(PROJECT_HOME)
    original_file = File.join(SUBMODULE_DIR, 'watir-robot/.yardoc')
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
