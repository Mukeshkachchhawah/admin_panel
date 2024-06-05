import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_admin_panal/utils/ui_helper.dart';
import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

/* 
class _AddProductViewState extends State<AddProductView> {
  late FirebaseFirestore db;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
                    hintText: "Title",
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
                    hintText: "Product Desc..",
                    labelText: "Product Desc.."),
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
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.photo,
                      size: 50,
                    ),
                  ),
                ),
              ),
              hSpace(),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          db.collection('product').add({
                            'name': titleController.text,
                            'description': descController.text,
                            'amount': amountController.text
                          }).then(
                            (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Notes Added Successfully')),
                              );

                              Navigator.pop(context);
                            },
                          ).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Failed to add note: $error')),
                            );
                          });
                        }
                      },
                      child: const Text("Add")))
            ],
          ),
        ),
      ),
    );
  }
}
 */

class _AddProductViewState extends State<AddProductView> {
  late FirebaseFirestore db;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image; // Initialize to null

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
                    hintText: "Title",
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
                    hintText: "Product Desc..",
                    labelText: "Product Desc.."),
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
              _image != null
                  ? Image.file(
                      File(_image!.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: const Icon(
                          Icons.photo,
                          size: 50,
                        ),
                      ),
                    ),
              hSpace(),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _image != null) {
                          db.collection('product').add({
                            'name': titleController.text,
                            'description': descController.text,
                            'amount': amountController.text,
                            'image': _image!.path,
                          }).then(
                            (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product Added Successfully')),
                              );
                              Navigator.pop(context);
                            },
                          ).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Failed to add product: $error')),
                            );
                          });
                        }
                      },
                      child: const Text("Add")))
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
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
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  _imgFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }
}
