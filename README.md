[![Codemagic build status](https://api.codemagic.io/apps/67808ebbeef0aea4f574a9ea/build-app-red-camera-roll/status_badge.svg)](https://codemagic.io/app/67808ebbeef0aea4f574a9ea/build-app-red-camera-roll/latest_build)

# Image-to-Result Calculator App

This Flutter app allows users to capture simple arithmetic expressions from images and compute their results. The app supports multiple configurations, including different themes, input methods, and storage engines for storing recent calculations. The app leverages BLOC architecture and handles multiple app flavors for different use cases.

## Features
- Capture arithmetic expressions from the camera roll or select from filesystem.
- Perform basic arithmetic operations (+, -, *, /) with two operands (e.g., `2 + 2`).
- Detect and compute the first arithmetic expression found in the image.
- Store and browse recent calculation results.
- Configurable themes: red or green.
- Configurable input methods: camera roll or file system.
- Two storage engines for results:
  - Encrypted file storage.
  - Non-encrypted database storage.

## App Variants
This app can be built into four different variants depending on the configuration:

1. **App Red Camera Roll**: Red theme, image input from camera roll.
2. **App Red Filesystem**: Red theme, image input from filesystem.
3. **App Green Filesystem**: Green theme, image input from filesystem.
4. **App Green Camera Roll**: Green theme, image input from camera roll.

## Installation
1. Clone this repository:
    ```bash
    git clone https://github.com/Thoriq-ha/calculation_ocr.git
    ```
2. Navigate to the project directory:
    ```bash
    cd calculation_ocr
    ```
3. Get the dependencies:
    ```bash
    flutter pub get
    ```

## Building the App
To build the app for different flavors, use the following commands:

### App Red Camera Roll
```bash
flutter run --flavor app_red_camera_roll -t lib/main_app_red_camera_roll.dart
```

### App Red file system
```bash
flutter run --flavor app_red_filesystem -t lib/main_app_red_filesystem.dart
```

### App Green Filesystem
```bash
flutter run --flavor app_green_filesystem -t lib/main_app_green_filesystem.dart
```

### App Green Camera Roll
```bash
flutter run --flavor app_green_camera_roll -t lib/main_app_green_camera_roll.dart
```

## Development
This project uses the **BLOC architecture** for state management and handling complex logic.

To debug different variants, refer to the pre-configured launch settings in `.vscode/launch.json`.

### Example Launch Configurations:
- `app_red_camera_roll Debug`
- `app_green_filesystem Release`
  
For example:
```json
{
    "name": "app_red_camera_roll Debug",
    "request": "launch",
    "type": "dart",
    "flutterMode": "debug",
    "args": [
        "--flavor",
        "app_red_camera_roll"
    ],
    "program": "lib/main_app_red_camera_roll.dart"
}
```

## Requirements
- Flutter SDK
- Dart
- Third-party libraries for OCR and image processing
- Encryption library for secure storage (for filesystem variant)
  
### Dependencies

This project relies on a number of third-party packages to handle various functionalities:

- **bloc**: State management library to manage the app's logic using the BLOC pattern.
- **cupertino_icons**: Provides iOS style icons used in Cupertino-styled Flutter apps.
- **dartz**: Functional programming library that provides functional types like `Either`, `Option`, and more.
- **device_info_plus**: Fetches information about the current device, useful for configuring the app based on device characteristics.
- **encrypt**: Used for encrypting and decrypting sensitive data when storing results to the file system.
- **equatable**: Simplifies value equality checks within the BLOC pattern.
- **flutter_bloc**: Extension of the BLOC package that integrates with Flutter for state management.
- **flutter_secure_storage**: Provides secure storage for sensitive information, such as encryption keys for the file system storage engine.
- **get_it**: A service locator for managing dependencies and making it easier to inject services into your app.
- **go_router**: A router package for Flutter apps that simplifies navigation and route handling.
- **google_mlkit_text_recognition**: A machine learning kit used for recognizing arithmetic expressions from images.
- **image_picker**: Enables selecting images from the gallery or taking pictures with the camera.
- **math_expressions**: A package to evaluate simple arithmetic expressions such as `1 + 2` after extracting them from images.
- **path**: Assists in manipulating and working with file system paths across platforms.
- **path_provider**: Provides access to commonly used locations in the file system, such as temp and app directories.
- **permission_handler**: Manages permissions needed to access the camera and storage.
- **shared_preferences**: Provides a simple way to persist data locally on the device (used in this project for storing settings and preferences).
- **sqflite**: A package for managing SQLite databases, used to store recent results in the non-encrypted storage engine.

### Dev Dependencies

- **flutter_launcher_icons**: A tool to generate app launcher icons for multiple platforms.
- **flutter_flavorizr**: Automates flavor management in Flutter, helping you easily configure and manage multiple app variants.

This combination of dependencies ensures that the app can efficiently handle everything from state management and expression recognition to secure data storage and multi-flavor support.

## Topics Covered
- Multiple app variants.
- Compile-time and run-time behavior control.
- Theme handling.
- Camera and file picker integration.
- Permission handling (camera, file picker).
- Encryption/decryption for secure storage.
- File system operations and database management.
