import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_auction/const/AppColorsConst.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProductItems extends StatefulWidget {
  const MyProductItems({Key? key}) : super(key: key);

  @override
  _MyProductItemsState createState() => _MyProductItemsState();
}

class _MyProductItemsState extends State<MyProductItems> {
  List _products = [];
  var _fireStoreInstanse = FirebaseFirestore.instance;
  var _currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    fetchProductsData();
    super.initState();
  }

  fetchProductsData() async {
    QuerySnapshot qn =
        await _fireStoreInstanse.collection("Product_data").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        if (qn.docs[i]["uId"] == _currentUser.toString()) {
          _products.add({
            "tblId": qn.docs[i]['tblId'],
            "uId": qn.docs[i]['uId'],
            "name": qn.docs[i]['name'],
            "description": qn.docs[i]['description'],
            "photo": qn.docs[i]['photo'],
            "minBidPrice": qn.docs[i]['minBidPrice'],
            "date": qn.docs[i]['date'],
            "time": qn.docs[i]['time'],
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('willPopScope');
        Navigator.of(context, rootNavigator: false).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColorsConst.deepOrrange,
          title: Text('My Auction Items'),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: ListView.builder(
                  itemCount: _products.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Ink.image(
                                    image: NetworkImage(
                                      _products[index]["photo"],
                                    ),
                                    height: 250,
                                    fit: BoxFit.cover,
                                    child: InkWell(
                                      onTap: () {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: " +
                                                "${_products[index]["name"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 24.sp),
                                          ),
                                          Text(
                                            "MinBid Price: " +
                                                "${_products[index]["minBidPrice"].toString()}",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "End Date: " +
                                                "${_products[index]["date"].toString() + "- ${_products[index]["time"].toString()}"}",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ))),
        ),
      ),
    );
  }
}
