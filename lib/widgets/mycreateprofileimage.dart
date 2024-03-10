import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as syspath;
import 'package:uuid/uuid.dart';

class MyProfileImage extends StatefulWidget {
  const MyProfileImage({super.key, this.imagelocalpath, this.editmode = false, this.viewmode=true});
  static String? pathToImage;
  final String? imagelocalpath;
  final bool editmode;
  final bool viewmode;

  static Future<String?> funcPaths(String? imagepath) async {
    if (_MyProfileImageState.isImageChanged != false){
      pathToImage = _MyProfileImageState.galleryImagePath!.path;
      return pathToImage;
    }
    else{
      pathToImage = imagepath;
      return pathToImage;
    }
  }

  static Future<String?> funcPath() async{
    if (_MyProfileImageState._imagepath != null){
      pathToImage = _MyProfileImageState.galleryImagePath?.path;
      return pathToImage;
    }
    else {
      pathToImage = _MyProfileImageState.galleryImagePath?.path;
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
  static bool isImageChanged = false;

  @override
  void initState() {
    super.initState();
      setState(() {
        if (widget.editmode == false){
          _imagepath = null;
          }
        else{
          if (isImageChanged != false){
            _imagepath = galleryImagePath?.path;
          }
          else{
            _imagepath = galleryImagePath?.path;
          }
          
        }
        
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
            widget.editmode != false // This means edit mode is true
              ? CircleAvatar(radius: 80, backgroundImage: _image != null
                ? FileImage(File(_image!.path)) // This means image changed in editmode
                : FileImage(File(widget.imagelocalpath!))) // This assigns profile image from db.
              : widget.imagelocalpath != null //View form condition
                ? CircleAvatar(backgroundImage: FileImage(File(widget.imagelocalpath!)), radius: 80,) // View form profile image
                : _imagepath != null // Create profile image form
                  ? CircleAvatar(backgroundImage: FileImage(File(_imagepath!)), radius: 80,)
                  : CircleAvatar(
                        radius: 80,
                        backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/profile_img02.jpeg') as ImageProvider,
                      ),
            widget.viewmode != false
              ? Positioned(
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
              )
              : const SizedBox(),
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
    });
  }

  Future<void> saveImage(path) async {
    final sourcePath = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = directory.path;
    const uuid = Uuid();

    if (newPath.isNotEmpty){
      final basenameWithExtension = '${uuid.v1()}${syspath.extension(path)}';
      galleryImagePath = await sourcePath.copy(syspath.join(newPath, basenameWithExtension));
    }
    else{
      throw "Please select profile image";
    }
  }

  Future<String?> loadImage() async {
    setState(() {
      _imagepath = galleryImagePath?.path;
    });
    return _imagepath;
  }
}

