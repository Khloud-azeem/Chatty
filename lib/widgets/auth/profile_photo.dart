import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto(this.pickImage, {Key? key}) : super(key: key);
  final void Function(String path) pickImage;

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  final ImagePicker _picker = ImagePicker();
  String _imagePath = '';

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      //doesn't update???
      setState(() {
        _imagePath = image.path;
        widget.pickImage(_imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: height * 0.07,
          backgroundImage:
              _imagePath.isEmpty ? FileImage(File(_imagePath)) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Profile photo")),
      ],
    );
  }
}
