import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/main.dart';

class MySignaturePage extends StatefulWidget {
  const MySignaturePage({super.key});

  @override
  State<MySignaturePage> createState() => _MySignaturePageState();
}

class _MySignaturePageState extends State<MySignaturePage> {
  SignatureController? controller;

  @override
  void initState() {
    super.initState();
    controller = SignatureController(
      penColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) =>
    MyScaffold(
      title: "Signature page",
      fontSize: 15,
      iconSize: 25,
      width: 300,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Signature(
              controller: controller!,
              backgroundColor: Colors.black,
              height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height*0.5 : MediaQuery.of(context).size.height*0.2,
              width: MediaQuery.of(context).size.width,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(0),
            child: buildButtons(context),
          ),

          Padding(
            padding: const EdgeInsets.all(0),
            child: buildSwapOrientation()
          ),
        ],
      ),
    );
  Widget buildSwapOrientation() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newOrientation = isPortrait ? Orientation.landscape : Orientation.portrait;
        controller!.clear();
        setOrientation(newOrientation);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide(color: Colors.black), horizontal: BorderSide(color: Colors.black))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPortrait
                ? Icons.screen_lock_portrait
                : Icons.screen_lock_landscape,
              size: 40,
            ),
            const SizedBox(width: 12,),
            const Text(
              'Tap to change the orientation',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
    color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildCheck(context),
        buildClear(),
      ],
    ),
  );

  Widget buildCheck(BuildContext context) => IconButton(
    iconSize: 36,
    icon: const Icon(Icons.check, color: Colors.green,),
    onPressed: () async {
      if (controller!.isNotEmpty){
        final signature = await exportSignature();
        if (context.mounted){
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySignaturePreviewPage(signature: signature))).then((value) async {
            controller!.clear();
            Navigator.of(context).pop();
          });
        }
      }
    },
  );

  Widget buildClear() => IconButton(
    iconSize: 36,
    icon: const Icon(Icons.clear, color: Colors.red,),
    onPressed: () => controller!.clear(),
  );

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      penStrokeWidth: 2,
      points: controller!.points,
    );
    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature!;
  }

  void setOrientation(Orientation orientation){
    if (orientation == Orientation.landscape){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
    else{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}

class MySignaturePreviewPage extends StatelessWidget {
  static String signatureImagePath = '';
  final Uint8List signature;
  static bool isActive = false;
  const MySignaturePreviewPage({super.key, required this.signature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text("Store Signature"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => storeSignature(context),
          ),
        ],
      ),
      body: Center(
        child: Image.memory(signature),
      ),
    );
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  Future storeSignature(BuildContext context) async {
    bool status;
    String directoryName = 'signature_images';
    if (Platform.isAndroid){
      status = await Permission.storage.status.isGranted;
    }
    else{
      status = await Permission.photos.status.isGranted;
    }
    if (!status){
      await Permission.storage.request();
    }
    // *********
    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';
    Directory directory;
    if (Platform.isAndroid){
      directory = await getApplicationDocumentsDirectory();
    }
    else{
      final tmpDirectoryPath = await getApplicationDocumentsDirectory();
      Directory newDirectory = (tmpDirectoryPath.parent).parent;
      if (!Directory('${newDirectory.path}/test_widget').existsSync()){
        directory = await Directory('${newDirectory.path}/test_widget').create(recursive: true);
      }
      directory = Directory('${newDirectory.path}/test_widget');
    }
    String path = directory.path;
    await Directory('$path/$directoryName').create(recursive: true);
    signatureImagePath = '$path/$directoryName/$name';

    File(signatureImagePath).writeAsBytesSync(signature);
    Directory(signatureImagePath).exists().then((value) {
      isActive = true;
      Navigator.of(context).pop();
    });
  }
}