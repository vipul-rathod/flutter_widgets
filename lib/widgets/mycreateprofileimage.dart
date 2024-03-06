import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as syspath;
import 'package:uuid/uuid.dart';


class CreateProfileImage extends StatefulWidget {
  const CreateProfileImage({super.key});
  static String? pathToImage;
  
  static Future<String?> funcPath() async{
    if (_CreateProfileImageState._imagepath == null){
      pathToImage = _CreateProfileImageState.galleryImagePath!.path;
      print ("Functool $pathToImage");
      return pathToImage;
    }
    else {
    pathToImage = _CreateProfileImageState._imagepath;
      print ("Functool $pathToImage");
      return pathToImage;
    }
  }

  @override
  State<CreateProfileImage> createState() => _CreateProfileImageState();
}

class _CreateProfileImageState extends State<CreateProfileImage> {
  File? _image;
  static String? _imagepath;
  static File? galleryImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadImage().then((value) {
      setState(() {
        _imagepath = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print ("Does this exists $_imagepath");
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
      // if (_image!.path.isEmpty){
        _image = File(image!.path);
        SaveImage(_image!.path);
      // }
      // else{
      //   print ("There's already image at $_image");
      // }
    });
  }

  Future<void> SaveImage(path) async {
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

  Future<String?> LoadImage() async {
    _imagepath = galleryImagePath!.path;
    setState(() {
      _imagepath = galleryImagePath!.path;
      print ("At load image function $_imagepath");
    });
    print ("Outside setState function $_imagepath");
    return _imagepath;
  }
}
