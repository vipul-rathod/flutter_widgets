import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as syspath;
import 'package:uuid/uuid.dart';

class CreateViewProfileImage extends StatefulWidget {
  const CreateViewProfileImage({super.key, this.imagelocalpath});
  static String? pathToImage;
  final String? imagelocalpath;
  
  static Future<String?> funcPath() async{
    if (_CreateViewProfileImageState._imagepath == null){
      pathToImage = _CreateViewProfileImageState.galleryImagePath!.path;
      return pathToImage;
    }
    else {
    pathToImage = _CreateViewProfileImageState._imagepath;
      return pathToImage;
    }
  }

  @override
  State<CreateViewProfileImage> createState() => _CreateViewProfileImageState();
}

class _CreateViewProfileImageState extends State<CreateViewProfileImage> {
  File? _image;
  static String? _imagepath;
  static File? galleryImagePath;

  @override
  void initState() {
    super.initState();
    loadImage().then((value) {
      setState(() {
        _imagepath = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            widget.imagelocalpath != null
            ? CircleAvatar(backgroundImage: FileImage(File(widget.imagelocalpath!)), radius: 80,)
            : _imagepath != null
            ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
            : CircleAvatar(
              radius: 80,
              backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/profile_img02.jpeg') as ImageProvider,
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
      saveImage(_image!.path);
    });
  }

  Future<void> saveImage(path) async {
    final sourcePath = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = directory.path;
    const uuid = Uuid();
    

    if (newPath.isNotEmpty){
      final basenameWithExtension = '${uuid.v1()}${syspath.extension(path)}';
      galleryImagePath = await sourcePath.copy('$newPath/$basenameWithExtension');
      // print(galleryImagePath!.path);
    }
    else{
      throw "Please select profile image";
    }
  }

  Future<String?> loadImage() async {
    _imagepath = galleryImagePath!.path;
    setState(() {
      _imagepath = galleryImagePath!.path;
    });
    return _imagepath;
  }
}

class MyProfileImage extends StatefulWidget {
  const MyProfileImage({super.key, this.imagelocalpath, this.editmode = false});
  static String? pathToImage;
  final String? imagelocalpath;
  final bool editmode;
  
  static Future<String?> funcPath() async{
    if (_MyProfileImageState._imagepath == null){
      print (" I am here at if functool");
      pathToImage = _MyProfileImageState.galleryImagePath!.path;
      return pathToImage;
    }
    else {
      print (" I am here at else functool");
      pathToImage = _MyProfileImageState._imagepath;
      return pathToImage;
    }
  }

  @override
  State<MyProfileImage> createState() => _MyProfileImageState();
}

class _MyProfileImageState extends State<MyProfileImage> {
  File? _image;
  static String? _imagepath;
  static File? galleryImagePath;
  bool isImageChanged = false;

  @override
  void initState() {
    super.initState();
    loadImage().then((value) {
      setState(() {
        if (widget.editmode == false){
          print ("I am at setState if condition");
          _imagepath = null;
        }
        else{
          isImageChanged = false;
          _imagepath = galleryImagePath!.path;
          print (" I am at setState else condition which is $isImageChanged");
        }
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            widget.editmode != false
            ? widget.imagelocalpath != null
              ? CircleAvatar(radius: 80, backgroundImage:
                isImageChanged != false
                ? FileImage(File(_imagepath!))
                : FileImage(File(widget.imagelocalpath!)) )
              : _imagepath != null
                ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
                : CircleAvatar(backgroundImage: FileImage(File(widget.imagelocalpath!)), radius: 80,)
            : widget.imagelocalpath != null
              ? _imagepath != null
                ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
                : CircleAvatar(backgroundImage: FileImage(File(widget.imagelocalpath!)), radius: 80,)
            : _imagepath != null
              ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
              : const CircleAvatar(backgroundImage: AssetImage('assets/images/profile_img02.jpeg')),

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
      saveImage(_image!.path);
      isImageChanged = true;
      print ("Pick image is $isImageChanged");
    });
  }

  Future<void> saveImage(path) async {
    final sourcePath = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = directory.path;
    const uuid = Uuid();
    

    if (newPath.isNotEmpty){
      final basenameWithExtension = '${uuid.v1()}${syspath.extension(path)}';
      galleryImagePath = await sourcePath.copy('$newPath/$basenameWithExtension');
    }
    else{
      throw "Please select profile image";
    }
  }

  Future<String?> loadImage() async {
    setState(() {
      _imagepath = galleryImagePath!.path;
    });
    return _imagepath!;
  }
}

