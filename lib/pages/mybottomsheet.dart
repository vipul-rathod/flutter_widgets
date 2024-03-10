import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => MyBottomSheetState();
}

class MyBottomSheetState extends State<MyBottomSheet> {
  static XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20
      ),
      child: Column(
        children: <Widget>[
          const Text('Choose profile photo',
            style: TextStyle( fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
              ),
              const SizedBox(width: 100,),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  void takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front
    );
    setState(() {
      imageFile = pickedFile;
    });
  }
}