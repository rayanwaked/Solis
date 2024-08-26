<img width="2081" alt="Screenshot 2024-08-26 at 3 22 19 PM" src="https://github.com/user-attachments/assets/a8531fb2-c2e0-434f-9e6b-77e51f31987e">

# Solis

Solis is single screen app that displays the user's weight, water in-take, and total step count. It utilizes SwiftUI and HealthKit for its main features.

## Project Structure

```
Solis/
├── Solis/
│   ├── Info
│   ├── Solis
│   └── SolisApp
├── Modules/
│   ├── Home/
│   │   └── HomeView
│   ├── HealthKit/
│   │   ├── HealthFetch
│   │   ├── HealthHelper
│   │   └── HealthManager
│   └── Assets/
│       ├── Preview Content/
│       ├── Assets
│       └── SIzes
```

## Overview of Major Files

### SolisApp.swift
The main entry point of the application, setting up the app structure and initial view.

### HomeView.swift
The main view of the application, displaying health data including weight trends, step count, and water intake.

### HealthKit Module
- **HealthFetch.swift**: Implements methods for fetching sample and statistics data from HealthKit.
- **HealthHelper.swift**: Defines helper structures and protocols for processing HealthKit data.
- **HealthManager.swift**: Manages HealthKit integration, authorization, and data fetching.

## Features

1. **Weight Tracking**: Displays a chart of the user's weight over the past week.
2. **Step Count**: Shows the user's step count for the current day.
3. **Water Intake**: Presents the user's water intake for the current day.
4. **HealthKit Integration**: Fetches and processes health data from Apple's HealthKit.

## HealthKit Integration

The app uses HealthKit to fetch the following types of data:
- Body Mass (Weight)
- Step Count
- Dietary Water

## Requirements

- iOS 17.0+
- Xcode 13.0+
- Swift 5.5+

## Getting Started

1. Clone the repository
2. Open the project in Xcode
3. Ensure you have the necessary provisioning profiles and certificates for HealthKit capabilities
4. Build and run the app on a simulator or physical device

## Usage

Upon first launch, the app will request authorization to access HealthKit data. Once granted, it will display the user's health snapshot including weight trends, daily step count, and water intake.

## Customization

The app uses custom font modifiers for consistent typography across the UI. These can be adjusted in the `HomeView.swift` file.

## Contributing

Contributions to Solis are welcome. Please feel free to submit a Pull Request.

## License

MIT License

Copyright (c) 2024 Rayan Waked

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
