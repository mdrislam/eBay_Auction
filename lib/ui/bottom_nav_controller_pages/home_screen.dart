import 'package:ebay_auction/const/AppColorsConst.dart';
import 'package:ebay_auction/ui/my_product_items.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auction_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _products = [];
  var _fireStoreInstanse = FirebaseFirestore.instance;

  fetchProductsData() async {
    QuerySnapshot qn =
        await _fireStoreInstanse.collection("Product_data").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
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
    });
  }

  @override
  void initState() {
    fetchProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          height: 150.h,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              color: AppColorsConst.deepOrrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "Add Auction",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => AuctionForm()));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          height: 150.h,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              color: AppColorsConst.deepOrrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "My Items",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => MyProductItems()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
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
                        )))
          ],
        )),
      ),
    );
  }
}
