This project contains the code required to retrieve and publish solar generation data from Bath and West Community 
Energy Company (BWCE)

The scripts fetch data from a solarlog installation which aggregates data from a number of local schools. After 
preparing the data it is then published to a Socrata data store.

## Installation and Setup

The code relies on the following:

* ncftp
* wget
* Java 1.7
* Ruby 2.3.0
* Bundler

These are the basic dependencies, Bundler and Rake can then be used to install the additional dependencies:

```
bundle install
```

You should then create and edit a `.env` file and add the following configuration:

```
DATASYNC_VERSION=1.7.2

DATASET_LOGGING=<id-of-dataset-to-log-to>

SOCRATA_USER=<user-name>
SOCRATA_PASS=<password>
SOCRATA_APP_TOKEN=<app-token>

SOLARLOG_USER=<solarlog-user>
SOLARLOG_PASS=<solarlog-pass>
SOLARLOG_HOST=bwce.measuremyenergy-monitoring.co.uk

```

Then run:

```
rake install
```

This will download the Socrata DataSync application used to publish data, it will be stored in the `vendor`
directory.

You then need to generate the configuration files used for the FTP and publication processes:

```
rake config:prepare
```

The configuration is stored in the `config` directory.

## School Configuration

The list of schools to be processed is defined in `config/schools.csv`. There is a name and an identifier for each 
school. The identifier is the unique identifier used by the solar log installation.

Add or remove schools from this list to change what data is synchronised. E.g. to only fetch data for a single school.

## Fetching the Data

The data is fetched via FTP using the `ncftp` command-line tool. The tool supports only fetching new and updated 
data from the FTP server making it easy to sync data between the server and the local machine.

To run the FTP process:

```
rake data:download
```

This will download all CSV files for the schools and place them below the `data` directory.

To combine the daily CSV files into a single large file per school:

```
rake data:combine
```

## Publishing the Data

TODO: this is still a work in progress.

The publication to Socrata is handled by DataSync as a "[headless job](http://socrata.github.io/datasync/guides/setup-standard-job-headless.html)"

The logging dataset in the `.env` file should be 
[setup as described in the DataSync documentation](http://socrata.github.io/datasync/resources/preferences-config.html#setting-up-logging-using-a-dataset).

