## Web Access
- [Dashboard - http://localhost:8000/simulated-hospital/](http://localhost:8000/simulated-hospital/)
  - [Health - http://localhost:8000/simulated-hospital/health](http://localhost:8000/simulated-hospital/health)
  - [Debug - http://localhost:8000/simulated-hospital/debug](http://localhost:8000/simulated-hospital/debug)
- [Static Assets - http://localhost:8000/simulated-hospital/static](http://localhost:8000/simulated-hospital/static)
- [Metrics (Prometheus) - http://localhost:9095/metrics](http://localhost:9095/metrics)

## Run
```
docker run --rm -it \
  -p 8000:8000 \
  -p 9095:9095 \
  frederickwong/simhospital:latest
```

## Build
Build using the command:
```
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t frederickwong/simhospital:latest \
  -t frederickwong/simhospital:v0.1.0 \
  --push \
  .
```

## Help
```
$ simhospital -h
Usage of simhospital:
  -allergies_file string
    	Path to a CSV file with the allergies and how often they occur. This file can be a local file or a GCS object. (default "configs/hl7_messages/allergies.csv")
  -boys_names string
    	Path to a CSV file containing historical boys names. This file can be a local file or a GCS object. (default "configs/hl7_messages/third_party/historicname_tcm77-254032-boys.csv")
  -clinical_note_types_file string
    	Path to a text file with the Clinical Note types. This file can be a local file or a GCS object. (default "configs/hl7_messages/third_party/note_types.txt")
  -cloud_dataset string
    	Dataset of the Cloud FHIR store; only relevant if -resource_output=cloud
  -cloud_datastore string
    	Datastore of the Cloud FHIR store; only relevant if -resource_output=cloud
  -cloud_location string
    	Location of the Cloud FHIR store; only relevant if -resource_output=cloud
  -cloud_project_id string
    	Project ID of the Cloud FHIR store; only relevant if -resource_output=cloud
  -dashboard_address string
    	Address for the dashboard to control Simulated Hospital (default ":8000")
  -dashboard_uri string
    	Base URI at which the dashboard and endpoints are available (default "simulated-hospital")
  -data_config_file string
    	Path to a YAML file with the configuration for data to populate HL7 fields that are not relevant to the use of the HL7 standard. This file can be a local file or a GCS object. (default "configs/hl7_messages/data.yml")
  -delete_patients_from_memory
    	Whether Simulated Hospital deletes patients after their pathways finish. Deleting saves memory but means you can't reuse the patient in another pathway
  -diagnoses_file string
    	Path to a CSV file with the diagnoses and how often they occur. This file can be a local file or a GCS object. (default "configs/hl7_messages/diagnoses.csv")
  -doctors_file string
    	Path to a YAML file with the doctors. This file can be a local file or a GCS object. (default "configs/hl7_messages/doctors.yml")
  -ethnicity_file string
    	Path to a CSV file with the ethnicities and how often they occur. This file can be a local file or a GCS object. (default "configs/hl7_messages/ethnicity.csv")
  -exclude_pathway_names string
    	Comma-separated list of pathway names, or regular expressions that match pathway names, for the pathways to exclude from running when pathway_manager_type=distribution. Pathways that match both -pathway_names and -exclude_pathway_names are excluded. Excluded pathways can still be run from the dashboard.
  -girls_names string
    	Path to a CSV file containing historical girls names. This file can be a local file or a GCS object. (default "configs/hl7_messages/third_party/historicname_tcm77-254032-girls.csv")
  -hardcoded_messages_dir string
    	Path to a directory with YAML files that contain hardcoded messages. This directory can be on the local file system or GCS. (default "configs/hardcoded_messages")
  -header_config_file string
    	Path to a YAML file with the configuration for the header of HL7 messages. This file can be a local file or a GCS object. (default "configs/hl7_messages/header.yml")
  -hl7_config_file string
    	Path to a YAML file with the possible values of HL7 fields related to how the HL7 standard is used. This file can be a local file or a GCS object. (default "configs/hl7_messages/hl7.yml")
  -hl7_timezone string
    	The location for the timezone for dates in the generated HL7 messages. The specified location must be installed on the operating system (default "UTC")
  -local_path string
    	Absolute path to the directory where Simulated Hospital is located. Set when running locally to use as a prefix to all default paths
  -locations_file string
    	Path to a YAML file with the definition of locations. This can be a local file or a GCS object. (default "configs/hl7_messages/locations.yml")
  -log_level string
    	The logging granularity. One of PANIC, FATAL, ERROR, WARN, INFO, DEBUG. Not case sensitive (default "INFO")
  -max_pathways int
    	Number of pathways to run before stopping. Pathways run from the dashboard do not count towards this limit. If negative, Simulated Hospital will keep running pathways indefinitely (default -1)
  -metrics_listen_address string
    	Address on which to expose an HTTP server with a /metrics endpoint for Prometheus to scrape (default ":9095")
  -mllp_destination string
    	Host:Port to which MLLP messages will be sent; only relevant if -output=mllp
  -mllp_keep_alive
    	Whether to send keep-alive messages on the MLLP connection; only relevant if -output=mllp
  -mllp_keep_alive_interval duration
    	Interval between keep-alive messages; only relevant if -output=mllp and -mllp_keep_alive=true (default 1m0s)
  -nouns_file string
    	Path to a text file containing english nouns. This file can be a local file or a GCS object. (default "configs/hl7_messages/third_party/nouns.txt")
  -order_profile_file string
    	Path to a YAML file with the definition of the order profiles. This file can be a local file or a GCS object. (default "configs/hl7_messages/order_profiles.yml")
  -output string
    	Where the generated HL7 messages will be sent: [stdout, mllp, file] (default "stdout")
  -output_file string
    	File path to write messages if -output=file (default "messages.out")
  -pathway_manager_type string
    	The way pathways are picked to be run. Supported: [distribution, deterministic] (default "distribution")
  -pathway_names string
    	Comma-separated list of pathway names for pathways to run. If pathway_manager_type=deterministic, this must be specified, and the pathways will be run in this order. If pathway_manager_type=distribution, can include regular expressions, or be empty - if empty, all pathways are included. Pathways that are not included here can still be run from the dashboard.
  -pathways_dir string
    	Path to a directory with YAML files with definitions of pathways. This directory can be on the local file system or GCS. (default "configs/pathways")
  -pathways_per_hour float
    	Number of pathways that should start per hour (default 1)
  -patient_class_file string
    	Path to a CSV file with the patient classes and types and how often they occur. This file can be a local file or a GCS object. (default "configs/hl7_messages/patient_class.csv")
  -procedures_file string
    	Path to a CSV file with the procedures and how often they occur. This file can be a local file or a GCS object. (default "configs/hl7_messages/procedures.csv")
  -resource_format string
    	The format in which to generate resources: [json, proto] (default "json")
  -resource_output string
    	Where the generated resources will be written: [stdout, file, cloud] (default "stdout")
  -resource_output_dir string
    	Path to the output directory for resource files; only relevant if -resource_output=file (default "resources")
  -sample_notes_directory string
    	Path to a directory with the sample notes. This directory can be on the local file system or GCS. (default "configs/hl7_messages/third_party/notes")
  -sleep_for duration
    	How long Simulated Hospital sleeps before checking if any new messages need to be generated (default 1s)
  -static_dir string
    	Directory for static assets (default "web/static")
  -surnames_file string
    	Path to a text file containing surnames. This file can be a local file or a GCS object. (default "configs/hl7_messages/third_party/surnames.txt")
```