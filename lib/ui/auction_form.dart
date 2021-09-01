import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_auction/const/AppColorsConst.dart';
import 'package:ebay_auction/widgets/customButton.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class AuctionForm extends StatefulWidget {
  const AuctionForm({Key? key}) : super(key: key);

  @override
  _AuctionFormState createState() => _AuctionFormState();
}

class _AuctionFormState extends State<AuctionForm> {
  TextEditingController _auctionDateController = TextEditingController();
  TextEditingController _auctionTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  String minBidPrice = "";
  String auctionDate = "";
  String auctionTime = "";
  File? _imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColorsConst.deepOrrange,
          title: Text('Add product for Auction'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                          child: _imageFile != null
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_imageFile!))),
                                )
                              : Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ))),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () {
                              _getStoragePermission();
                              _showPicker(context);
                            },
                            child: Text(
                              "Select",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: AppColorsConst.deepOrrange,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Product Name ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => name = value),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Product Description ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => description = value),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Minimum Bid Price ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => minBidPrice = value),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _auctionDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Select auction end date ",
                          border: OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: () => _selectDateFromPicker(context),
                            icon: Icon(Icons.calendar_today_outlined),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => auctionDate = value),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _auctionTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Select auction end Time ",
                          border: OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: () => _selectTimeFromPicker(context),
                            icon: Icon(Icons.timer),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => auctionTime = value),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    customButton(
                        "Save",
                        () => {
                              if (_imageFile.toString().isEmpty)
                                {
                                  Fluttertoast.showToast(
                                      msg: " Select a Image File!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.redAccent),
                                  print("empty")
                                }
                              else
                                {
                                  if (_formKey.currentState!.validate())
                                    {insertDataToDB()}
                                }
                            })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _getStoragePermission() async {
    bool permissionGranted = false;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
    return permissionGranted;
  }

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 20),
        firstDate: DateTime(DateTime.now().year - 30),
        lastDate: DateTime(DateTime.now().year));
    if (picked != null) {
      setState(() {
        _auctionDateController.text =
            "${picked.day}/ ${picked.month}/ ${picked.year} ";
      });
    }
  }

  Future<void> _selectTimeFromPicker(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        _auctionTimeController.text = "${formattedTime}";
      });
    }
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure ?"),
              content: Text("Do you want to leave without saving?"),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Yes"),
                ),
              ],
            ));
    return shouldPop ?? false;
  }

  Future _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        pickedImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Pick Image From Gallery
  Future pickedImage() async {
    print("Cheak");
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //Get from Camera
  Future _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //Upload Imagem to FireBase Storage
  Future<String> uploadImage(File image) async {
    var url;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  //Save data to FireStore
  insertDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var _currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Product_data");

    await uploadImage(_imageFile!).then((value) => {
          _collectionRef
              .doc(_collectionRef.doc().id)
              .set({
                "tblId": _collectionRef.doc().id,
                "uId": _currentUser!.uid,
                "name": name,
                "description": description,
                "photo": value,
                "minBidPrice": minBidPrice,
                "date": _auctionDateController.text,
                "time": _auctionTimeController.text,
              })
              .then(
                (value) => Navigator.of(context).pop(),
              )
              .onError((error, stackTrace) =>
                  //Fluttertoast.showToast(msg: "Something was Wrong . $error")
                  print("Error: " + error.toString()))
        });
  }
}
