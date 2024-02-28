import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_widgets/pages/mybottomsheet.dart';

class MyProfileImage extends StatefulWidget {
  const MyProfileImage({super.key});

  @override
  State<MyProfileImage> createState() => MyProfileImageState();
}

class MyProfileImageState extends State<MyProfileImage> {
  // String imgfile = MyBottomSheetState.imageFile!.path;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: MyBottomSheetState.imageFile == null 
          ? const AssetImage("assets/images/profile_img02.jpeg") as ImageProvider
          : FileImage(File(MyBottomSheetState.imageFile!.path))
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder: ((builder) => const MyBottomSheet()));
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
}