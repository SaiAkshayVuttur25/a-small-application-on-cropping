// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image/Icon'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),        
          ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            imageFile == null
                ? Image.asset('assets/no_profile_image.png', height: 300.0, width: 300.0,)
                : ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
                child: Image.file(imageFile!, height: 300.0, width: 300.0, fit: BoxFit.fill,)
            ),
            const SizedBox(height: 20.0,),
            // ElevatedButton(
            //   onPressed: () async {
            //     Map<Permission, PermissionStatus> statuses = await [
            //       Permission.storage, Permission.camera,
            //     ].request();
            //     if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
            //       showImagePicker(context);
            //     } else {
            //       print('no permission provided');
            //     }
            //   },
            //   child: Text('Select Image'),
            // ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          child: const Column(
                            children: [
                              Icon(Icons.image, size: 60.0,),
                              SizedBox(height: 12.0),
                              Text(
                                "Gallery",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              )
                            ],
                          ),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.pop(context);
                          },
                        )),
                    Expanded(
                        child: InkWell(
                          child: const SizedBox(
                            child: Column(
                              children: [
                                Icon(Icons.camera_alt, size: 60.0,),
                                SizedBox(height: 12.0),
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _imgFromCamera();
                            Navigator.pop(context);
                          },
                        ))
                  ],
                )),
          );
        }
    );
  }

  _imgFromGallery() async {
    await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    ).then((value){
      if(value != null){
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    ).then((value){
      if(value != null){
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imgFile.path,
    aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // Example aspect ratio
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Image Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Image Cropper',
      )
    ],
  );

  if (croppedFile != null) {
    imageCache.clear();
    setState(() {
      imageFile = File(croppedFile.path);
    });
  }
}
}
