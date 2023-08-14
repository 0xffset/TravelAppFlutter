/// Author: Rogger G. Diaz
///  Mat. 2020-9618

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageSave extends StatefulWidget {
  final Function imageSave;
  const ImageSave(this.imageSave);

  @override
  State<ImageSave> createState() => _ImageSaveState();
}

class _ImageSaveState extends State<ImageSave> {
  File? _imageFile;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxHeight: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImagePath = await _imageFile!.copy('${appDir.path}/$fileName');

    widget.imageSave(saveImagePath);
  }

  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.gallery, maxHeight: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImagePath = await _imageFile!.copy('${appDir.path}/$fileName');

    widget.imageSave(saveImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.deepPurple),
            ),
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  )
                : const Center(child: Text('Not photo selected yet')),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _takePictureFromGallery,
                icon: const Icon(Icons.image),
                label: const Text('Add a new photo '),
              ),
              TextButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera),
                label: const Text('Take photo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
