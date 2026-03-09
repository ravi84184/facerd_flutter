import 'package:facerd_flutter/facerd_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? result;

  Future<void> capture() async {
    final status = await RDDetector.checkFaceRD();
    switch (status) {
      case RDDeviceStatus.ready:
        // proceed with capture
        String pidOptions = '''<PidOptions ver="1.0" env="P">
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
        </PidOptions>
        ''';

        result = await FaceRDPlugin.captureFace(pidOptions);
        setState(() {});
        break;
      case RDDeviceStatus.notInstalled:
        // prompt user to install FaceRD
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FaceRD Test")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: capture, child: Text("Capture Face")),
            Text("$result"),
          ],
        ),
      ),
    );
  }
}
