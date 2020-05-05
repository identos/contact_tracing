# Contact Tracing Android App

The contact tracing app enables identification and monitoring of devices(and thus individuals) the user has come in contact with in the event of a positive COVID-19 diagnosis.

## Getting Started

Clone repo and open with the Android Studio IDE, app is in buildable state and the debug and release versions can be ran using the appropriate build variants.

This project was built using the Android Studio v3.6.1 and gradle version 5.6.4, these versions are recommended but other versions should work.

### Setup

The following files may need modification to fully deploy the app 

- ./keystore
- ./app/source/main/assets/settings.json
	- BASE_URL_TO_API
	- API_KEY
- ./app/google-services.json
