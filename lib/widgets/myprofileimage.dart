import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:test_widgets/pages/mybottomsheet.dart';
import 'package:image_picker/image_picker.dart';


class MyProfileImage extends StatefulWidget {
  const MyProfileImage({super.key});

  @override
  State<MyProfileImage> createState() => MyProfileImageState();
}

class MyProfileImageState extends State<MyProfileImage> {
  static XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  // String imgfile = MyBottomSheetState.imageFile!.path;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: imageFile == null 
          ? const AssetImage("assets/images/profile_img02.jpeg") as ImageProvider
          : FileImage(File(imageFile!.path))
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet(){
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