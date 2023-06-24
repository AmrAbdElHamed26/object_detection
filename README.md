# Object Recognition 

Object Recognition is a project that utilizes AI to recognize various objects using the MobileNet model. The goal of this project is to provide assistance to visually impaired individuals by providing audio descriptions of their surroundings.

## Features

- Object recognition using the MobileNet model
- Sound output to describe objects in the scene
- Responsive UI using media queries
- Splash screen for a polished user experience
- Camera stream for real-time object detection


## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)

### Installation

1. Clone the repository:

2. Navigate to the project directory:


3. Install dependencies:


4. Connect your device or start an emulator.

5. Run the application:


### Troubleshooting

If you encounter an error related to TFLite not compiling the model, you may need to modify the TFLite package configuration. Follow these steps:

1. Locate the TFLite package in your project's dependencies. The package should be specified in your `pubspec.yaml` file.

2. Open the TFLite package:


3. Replace `compile` with `implementation` in the `build.gradle` file.


4. Save the changes and re-run the application.

## Contributing

Contributions to Object Recognition for Blind People are welcome! Here are a few ways you can contribute:

- Report bugs or issues
- Suggest new features or enhancements
- Submit pull requests

Please read our [Contribution Guidelines](CONTRIBUTING.md) for more information on how to contribute.




