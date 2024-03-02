import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


class MyProfileImage extends StatefulWidget {
  const MyProfileImage({super.key});

  @override
  State<MyProfileImage> createState() => MyProfileImageState();
}

class MyProfileImageState extends State<MyProfileImage> {
  static XFile? imageFile;
  XFile? pickedFile;
  final ImagePicker picker = ImagePicker();
  final uuid = const Uuid();
  static File? newFilePath;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: imageFile == null
          ? null
          : FileImage(File(imageFile!.path)),
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
                  setState(() {
                    takePhoto(ImageSource.camera);
                  });
                },
              ),
              const SizedBox(width: 100,),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                onPressed: () {
                  setState(() {
                    takePhoto(ImageSource.gallery);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<XFile?> takePhoto(ImageSource source) async {
    pickedFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front
    );
  Future<File?> saveImage(XFile? pickFile)async{
    try{
      final sourcePath = File(pickFile!.path);
      final directory = await getApplicationDocumentsDirectory();
      final newPath = directory.path;
      if (newPath.isNotEmpty){
        final basenameWithExtension = '${uuid.v1()}${path.extension(pickFile.path)}';
        newFilePath = await sourcePath.copy('$newPath/$basenameWithExtension');
        imageFile = pickFile;
        // return newFilePath;
      }
    }
      on Error catch(e){
        throw "Error in loading image path";
      }
      return newFilePath;
    }
    if (pickedFile!.path.isNotEmpty){
      saveImage(pickedFile);
      setState(() {
        imageFile = pickedFile;
      });
      return imageFile;
    }
    else{
      return imageFile;
    }


  // setState(() {
  //   imageFile = pickedFile;
  //   saveImage(imageFile);
  // });
  }
}


class MyViewProfileImage extends StatefulWidget {
  String? imagePath;
  MyViewProfileImage({super.key, required this.imagePath});

  @override
  State<MyViewProfileImage> createState() => MyViewProfileImageState(imagePath);
}

class MyViewProfileImageState extends State<MyViewProfileImage> {
  String? imagePath;
  MyViewProfileImageState(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: FileImage(File(imagePath!)),
        ),
      ],
    );
  }
}