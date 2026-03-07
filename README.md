## facerd_flutter

**facerd_flutter** is a Flutter plugin that integrates with the FaceRD RD (Registered Device) face capture application.  
It lets you:

- **Check** whether the FaceRD RD app is installed on the device.
- **Trigger** a face capture flow via FaceRD using XML `PidOptions`.

The plugin exposes a simple Dart API on top of platform method channels.

---

## Installation

- **Add dependency** to your app's `pubspec.yaml`:

```yaml
dependencies:
  facerd_flutter: latest
```

- Then run:

```bash
flutter pub get
```

> **Version compatibility**
>
> - Dart SDK: `>=3.10.4 <4.0.0`
> - Flutter: `>=3.3.0`

Make sure your app's `environment` section is compatible with these ranges.

---

## Android integration

- **Minimum setup**

The plugin uses a `MethodChannel` named `facerd_plugin` with an Android implementation in `FacerdFlutterPlugin`.  
Typical integration steps:

- Ensure your app is using **AndroidX** and a modern `compileSdkVersion` (e.g. 34 or higher).
- Use the default Flutter embedding (v2) which registers the plugin automatically.

- **FaceRD RD app**

This plugin assumes the **FaceRD Registered Device** application is installed on the device.  
If it isn't installed, `isFaceRDInstalled` returns `false` and `captureFace` will fail.

---

## iOS integration

The plugin defines an iOS implementation class `FacerdFlutterPlugin` which is registered automatically in a standard Flutter iOS project.

General requirements:

- iOS 11+ recommended.
- Use the default Flutter iOS template with Swift.

No additional Info.plist keys are required by the plugin itself, but the underlying FaceRD app may have its own requirements.

---

## Usage

Import the plugin in your Dart code:

```dart
import 'package:facerd_flutter/facerd_flutter.dart';
```

### 1. Check if FaceRD is installed

You can check directly via `FaceRDPlugin`:

```dart
final installed = await FaceRDPlugin.isFaceRDInstalled();
if (!installed) {
  // Show message or navigate user to install FaceRD app
}
```

Or use the higher-level `RDDetector` helper:

```dart
import 'package:facerd_flutter/src/rd_detector.dart';

final status = await RDDetector.checkFaceRD();
switch (status) {
  case RDDeviceStatus.ready:
    // proceed with capture
    break;
  case RDDeviceStatus.notInstalled:
    // prompt user to install FaceRD
    break;
}
```

> **Note**: `RDDetector` is a simple Dart helper around the same method channel, returning `RDDeviceStatus.ready` or `RDDeviceStatus.notInstalled`.

### 2. Capture face using FaceRD

Use `FaceRDPlugin.captureFace` with a valid `PidOptions` XML string:

```dart
import 'package:facerd_flutter/facerd_flutter.dart';

Future<void> captureFace() async {
  const pidOptions = '''<PidOptions ver="1.0" env="P">
  <Opts
    format="0"
    pidVer="2.0"
    timeout="10000"
    otp=""
    wadh=""
  />
  <CustOpts>
    <Param name="txnId" value="123456789"/>
    <Param name="language" value="en"/>
  </CustOpts>
</PidOptions>''';

  try {
    final result = await FaceRDPlugin.captureFace(pidOptions);
    // `result` contains the PID XML / response from FaceRD
  } on PlatformException catch (e) {
    // Handle errors from the platform side
  }
}
```

The exact structure of `PidOptions` and the expected response format is defined by the FaceRD RD specification.  
Ensure you follow the official RD documentation for production usage (PID encryption, `wadh`, security, etc.).

---

## Example app

This repository contains an **example** Flutter app under the `example/` directory that demonstrates:

- Checking whether FaceRD is installed.
- Triggering a face capture with sample `PidOptions`.
- Displaying the capture result.

To run the example:

```bash
cd example
flutter pub get
flutter run
```

Make sure the FaceRD app is installed on your test device/emulator and registered as an RD service.

---

## API reference

### `FaceRDPlugin`

- **Channel**: `facerd_plugin`
- **Methods**:
  - `static Future<String?> captureFace(String pidOptions)`
    - Sends `PidOptions` XML to the platform layer and returns the FaceRD response (e.g. PID XML).
  - `static Future<bool> isFaceRDInstalled()`
    - Returns `true` if the FaceRD app is installed, otherwise `false`.

### `RDDetector`

- `static Future<bool> isFaceRDInstalled()`
  - Same as `FaceRDPlugin.isFaceRDInstalled()`.
- `static Future<RDDeviceStatus> checkFaceRD()`
  - Returns `RDDeviceStatus.ready` or `RDDeviceStatus.notInstalled`.

---

## Version management / publishing

- **Plugin version**: currently `0.0.1` in `pubspec.yaml`.
- When you publish new versions:
  - Update the `version:` field in `pubspec.yaml` following semantic versioning (`MAJOR.MINOR.PATCH`).
  - Tag releases in your VCS (e.g. `v0.0.2`, `v0.1.0`).
  - Update the dependency snippet in this README to the latest stable version.

Apps depending on this plugin should use a **caret constraint** for automatic non-breaking updates, for example:

```yaml
dependencies:
  facerd_flutter: ^0.1.0
```

This allows updates up to (but not including) the next major version.

---

## Troubleshooting

- **`isFaceRDInstalled` returns false**
  - Verify that the FaceRD RD app is installed and enabled.
  - Ensure you are testing on a real device (some RD apps may not work on emulators).

- **`captureFace` throws `PlatformException`**
  - Check the exception `code` and `message` for platform-specific details.
  - Validate your `PidOptions` XML against the latest RD specification.

- **Build or integration issues**
  - Ensure your Flutter version is `>=3.3.0`.
  - Run `flutter clean && flutter pub get`.
  - Verify Android/iOS minimum versions meet RD app requirements.

