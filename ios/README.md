# Contact Tracing iOS App

Contact Tracing api is the open source implementation for contact tracing.

## Building the code

1. Install Xcode
2. Clone the repository
3. Open project from Xcode

### Configuration

./ContactTracer/Code/Api/ContractTracerApi.swift 
- Update BASE_URL_TO_API in 

./ContactTracer/Code/Api/Endpoint.swift 
- Update API_KEY

GoogleService-Info.plist
- for firebase use


## Debugging Communication

ContactEvents.swift provides an interface to view Bluetooth communications

## Directory Structure
<pre>
├── Api                                 # Server Communications
│   └── ContactTracerApi.swift          # Implementation of Endpoints for API
│   └── Endpoint.swift                  # Defines interfaces/enums required for API
├── Bluetooth                           # Files pertaining to Managing Bluetooth communication (Peripheral and Scanner)
│   └── ContactManager.swift            # Manages Peripheral and Scanner
│   └── ContactPeripheral.swift         # Gatt server that enables devices to connect and retrieve ContactPayload data.
│   └── ContactScanner.swift            # Bluetooth scanner connects to devices and requests ContactPayload data.
├── Components                          # Simple UI Components
│   └── TextViewVC.swift                # Bordered UITextView
│   └── TransitionDelegate.swift        # Delegate for VC animations
├── Controllers                         # UIViewControllers
│   └── ContactEventsVC.swift           # Debugging view for Bluetooth communications
│   └── ContactPayloadCell.swift        # Cell renderer for payload
│   └── ContactInfoVC.swift             # Phone Number entry
│   └── InfoVC.swift                    # Introduction
│   └── OtpVC.swift                     # One Time Password entry
│   └── StatusOffVC.swift               # Status when Bluetooth is off
│   └── StatusUnauthorizedVC.swift      # Status when Bluetooth is disabled for app
│   └── StatusVC.swift                  # Status when Bluetooth enabled and permitted
│   └── TurnOnBluetoothVC.swift         # Prompt to enable Bluetooth
├── Extensions                          # Add-on functionality for app
├── Model               
│   └── ContactConfig.swift             # Model for app configuration
│   └── ContactPayload.swift            # Model for payload data sent between devices
│   └── Navigation.swift                # Model representing Navigation for App
│   └── UserDefaults+UserInfp.swift     # Extension of User Defaults to Store model data
└── AppDelegate.swift
└── ContactTracerAppVc.swift  
</pre>              
