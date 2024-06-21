import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:user_admin_panal/utils/ui_helper.dart';
import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  late FirebaseFirestore db;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  XFile? _image; // Initialize to null

  final storageRef = FirebaseStorage.instance.ref();
  String imgPath = '';
  bool isUploading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance; // Firebase initialize
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: userAdminPenal(),
    );
  }

  userAdminPenal() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              hSpace(mHight: 40),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Product Name",
                    labelText: "Product Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              hSpace(),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Product Description",
                    labelText: "Product Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product desc...';
                  }
                  return null;
                },
              ),
              hSpace(),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product amount';
                  }
                  return null;
                },
              ),
              hSpace(),
              InkWell(
                onTap: () {
                  _showPicker();
                },
                child: imgPath != ""
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(File(imgPath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15)
                            /* image: DecorationImage(
                                image:
                                    AssetImage("assets/empty_product.webp")) */
                            ),
                        child: Center(
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ),
              hSpace(),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _image != null) {
                        setState(() {
                          isUploading = true;
                        });

                        try {
                          var timeMills = DateTime.now().millisecondsSinceEpoch;
                          var uploadRef = storageRef.child(
                              'images/img_$timeMills.jpg'); // image path in firebase

                          // Uploading the image file
                          var uploadTask =
                              await uploadRef.putFile(File(_image!.path));
                          debugPrint("Upload Task $uploadTask");
                          var downloadUrl = await uploadRef.getDownloadURL();
                          debugPrint(
                              "File uploaded successfully. Download URL: $downloadUrl ");

                          // Adding the product details to Firestore
                          await db.collection('product').add({
                            'name': titleController.text,
                            'description': descController.text,
                            'amount': amountController.text,
                            'image': downloadUrl,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Product Added Successfully')),
                          );
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to add product: $error')),
                          );
                        } finally {
                          setState(() {
                            isUploading = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill out all fields and select an image')),
                        );
                      }
                    },
                    child: isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add"),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                hSpace(),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    try {
      var imgXFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (imgXFile != null) {
        setState(() {
          _image = imgXFile;
          imgPath = imgXFile.path;
        });
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  _imgFromGallery() async {
    try {
      var imgXFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imgXFile != null) {
        setState(() {
          _image = imgXFile;
          imgPath = imgXFile.path;
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }
}
