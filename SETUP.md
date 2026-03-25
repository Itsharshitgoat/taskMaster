# Task Master - Setup Instructions for Android

Follow these steps to build and run Task Master on an Android emulator or device.

## Prerequisites
- Flutter SDK 3.0+ installed
- Dart SDK 3.0+ installed
- Android Studio installed with Android SDK and an active Android Emulator, OR a physical Android device connected via USB with "USB Debugging" enabled.

## Setup Steps

1. **Clone/Navigate to the Repository**
   Make sure you are in the root directory of the "Task Master" Flutter project.
   ```bash
   cd task_master
   ```

2. **Get Dependencies**
   Run the following command to download all required packages (sqflite, provider, shared_preferences, etc.):
   ```bash
   flutter pub get
   ```

3. **Connect a Device**
   Ensure your Android emulator is running or your physical device is connected. Verify the connection by running:
   ```bash
   flutter devices
   ```

4. **Run the App**
   To build and launch the app on your connected Android device/emulator:
   ```bash
   flutter run -d android
   ```

5. **Build APK (Optional)**
   To create a production-ready APK for installation on other devices:
   ```bash
   flutter build apk --release
   ```
   The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

## Features Included
- Local persistence using SQLite.
- Undo/Redo mechanism via Stack in TaskProvider.
- Light/Dark mode toggling using SharedPreferences.
- Smooth Material Design interface mapping closely to the provided screens.
