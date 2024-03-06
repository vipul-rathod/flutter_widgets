import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as syspath;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CreateProfileImage extends StatefulWidget {
  const CreateProfileImage({super.key});
  static String? pathToImage;
  
  // static Future<String?> funcPath() async{
  //   pathToImage = _CreateProfileImageState._imagepath;
  //   return pathToImage;
  // }

  @override
  State<CreateProfileImage> createState() => _CreateProfileImageState();
}

class _CreateProfileImageState extends State<CreateProfileImage> {
  File? _image;
  static String? _imagepath;

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

  Future<String?> LoadImage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
    });
  }
}
