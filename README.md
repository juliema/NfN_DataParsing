Scripts for Parsing Notes from Nature Data
==============================

To run the scripts on the datasets:

perl program.pl  filename  collection

### getdata.collection.pl  

      1. Number of records in the file and number of skipped or empty records.
      2. Number of unique transcribers and number of transcriptions per transcriber - as a separate file
      3. Number of countries represented - this is raw and needs to go through the Country data clean up pipeline.
      
      output files:
            1. collection.CountryData.txt - unique countries and number of records per country
            2. collection.CollectorData.txt -- unique transcribers and number of transcriptions 

### Country Data Pipeline:

      1. Raw country data comes from the getdata.collection.pl script and goes into the DataMigrators (more soon)
                  Report-output file then gets a final clean up with 
                  cleancountrydata.pl
                  

### TranscriptionTime.collection.pl

      1. Gives the number of records that have at least 5 datapoints (usually locality, country, county, collector, date)
      
      output files:
            1. FiveCellsTime.collection.txt - gives the length of time in seconds each of these records took.
            2. StartHour.collection.txt - gives the time each record was started.
            

