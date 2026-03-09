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


## Usage

Import the plugin in your Dart code:

```dart
import 'package:facerd_flutter/facerd_flutter.dart';
```

### 1. Check if FaceRD is installed

You can check directly via `FaceRDPlugin`:


```dart
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

