require 'rubygems'
require 'rake'
require 'rake/clean'
require 'json'
require 'csv'
require 'dotenv'

Dotenv.load

DATA_DIR="data"

#parse school CSV files to parameterise some tasks
def schools
  schools = {}
  CSV.foreach("config/schools.csv") do |row|
    schools[ row[1] ] = row[0]
  end
  schools
end

task :install do
  sh %{mkdir -p vendor}
  sh %{mkdir -p data}
  sh %{wget -N -nd -P vendor https://github.com/socrata/datasync/releases/download/#{ENV["DATASYNC_VERSION"]}/DataSync-#{ENV["DATASYNC_VERSION"]}.jar }
end

namespace :config do
  desc "Prepare config files from .env data"
  task :prepare => [:datasync_config, :ftp_config]

  desc "Prepare Socrata DataSync configuration"
  task :datasync_config do
    config = JSON.load( File.new("config/datasync-config-template.json") )
    config["username"] = ENV["SOCRATA_USER"]
    config["password"] = ENV["SOCRATA_PASS"]
    config["appToken"] = ENV["SOCRATA_APP_TOKEN"]
    config["logDatasetID"] = ENV["DATASET_LOGGING"]
    File.open("config/config.json", "w") do |f|
      f.puts JSON.generate( config )
    end
  end

  desc "Prepare ncftp configuration"
  task :ftp_config do
    File.open("config/ncftp_config", "w") do |f|
      f.puts "host #{ENV["SOLARLOG_HOST"]}"
      f.puts "user #{ENV["SOLARLOG_USER"]}"
      f.puts "pass #{ENV["SOLARLOG_PASS"]}"
    end
  end

  desc "Clean up configuration"
  task :clean do
    CLEAN.include ["config/ncftp_config", "datasync-config-template.json"]
    Rake::Task["clean"].invoke
  end
end

namespace :data do

  desc "carry out FTP download of data from solarlog server"
  task :download do
    sh %{bin/ftp_data.sh #{ schools.keys.join(" ") }}
  end

  desc "Combine daily reading files into single CSV"
  task :combine do
    sh %{ruby bin/combine_school_data.rb #{ schools.keys.join(" ") } }
  end

  desc "Clean all downloads. WARNING will require a full download of all data in future"
  task :clean do
    CLEAN.include ["#{DATA_DIR}/*.csv", "#{DATA_DIR}/**/*.csv"]
    Rake::Task["clean"].invoke
  end

end

namespace :publish do
  #publish archives
  #publish other file(s)?
end

#task :upload_about_bath do
#  sh %{java -jar vendor/DataSync-#{ENV["DATASYNC_VERSION"]}.jar -f data/about-bath.csv -i #{ENV["DATASET_ABOUT_BATH"]} -ph true -c config/config.json -cf config/control.json }
#end

#Document dependencies
#Task to upload each school
#Configuration for each school

#Datasets for each school
#Overall dataset, which contains metadata

#Not updating?
#271096109
#808303126/