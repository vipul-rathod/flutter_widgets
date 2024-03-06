import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as syspath;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    print ("New file path is $newFilePath");
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: newFilePath == null && imageFile != null ? null : FileImage(File(imageFile!.path))
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
    setState(() {
      imageFile = pickedFile;
    });
    
    Future<File?> saveImage(XFile? pickFile)async{
      try{
        final sourcePath = File(pickFile!.path);
        final directory = await getApplicationDocumentsDirectory();
        final newPath = directory.path;
        if (newPath.isNotEmpty){
          final basenameWithExtension = '${uuid.v1()}${syspath.extension(pickFile.path)}';
          newFilePath = await sourcePath.copy('$newPath/$basenameWithExtension');
          // imageFile = pickFile;
          // return newFilePath;
        }
      }
      on Error catch(e){
        throw "Error in loading image path";
      }
      // return newFilePath;
    }
    // if (pickedFile!.path.isNotEmpty){
      // saveImage(pickedFile);
      // setState(() {
      //   imageFile = pickedFile;
      //   // newFilePath;
      // });
      // return null;
    // }
    // else{
      // return null;
    // }
  }
}

class CreateProfileImage extends StatefulWidget {
  const CreateProfileImage({super.key});

  @override
  State<CreateProfileImage> createState() => _CreateProfileImageState();
}

class _CreateProfileImageState extends State<CreateProfileImage> {
  File? _image;
  String? _imagepath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            _imagepath != null
            ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
            : CircleAvatar(
              radius: 80,
              backgroundImage: _image != null ? FileImage(_image!) : null,
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  pickImage();
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.teal,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      SaveImage(_image!.path);
    });
  }

  Future<void> SaveImage(path) async {
    final sourcePath = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = directory.path;
    const uuid = Uuid();
    final File? galleryImagePath;

    if (newPath.isNotEmpty){
      final basenameWithExtension = '${uuid.v1()}${syspath.extension(path)}';
      galleryImagePath = await sourcePath.copy('$newPath/$basenameWithExtension');
      SharedPreferences saveimage = await SharedPreferences.getInstance();
      saveimage.setString("imagepath", galleryImagePath.path);
      print(galleryImagePath.path);
    }
    else{
      throw "Please select profile image";
    }
  }

  Future<void> LoadImage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
    });
  }
}

class MyEditProfileImage extends StatefulWidget {
  const MyEditProfileImage({super.key, this.path});
  final String? path;
  @override
  State<MyEditProfileImage> createState() => MyEditProfileImageState();
}

class MyEditProfileImageState extends State<MyEditProfileImage> {
  static XFile? imageFile;
  XFile? pickedFile;
  final ImagePicker picker = ImagePicker();
  final uuid = const Uuid();
  static File? newFilePath;
  
  @override
  Widget build(BuildContext context) {
    if (imageFile!.path.isEmpty){
      imageFile = null;
    }
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: imageFile?.path.isEmpty != true ? FileImage(File(imageFile!.path)) : FileImage(File(widget.path!)) //Main Condition
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
        final basenameWithExtension = '${uuid.v1()}${syspath.extension(pickFile.path)}';
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
      return null;
    }
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