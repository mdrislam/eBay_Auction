import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_auction/const/AppColorsConst.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatefulWidget {
  String tbleId;

  ProductDetails({required this.tbleId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var path ="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";
  String photo = '';
  String name = '';
  String description = '';
  String minBidRate = '';
  String endDate = '';

  var _fireStoreInstanse = FirebaseFirestore.instance;

  fetchProductsData() async {
    var collection = FirebaseFirestore.instance.collection('Product_data');
    await FirebaseFirestore.instance
        .collection('Product_data')
        .where("tblId", isEqualTo: widget.tbleId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.length > 0) {
        setState(() {
          snapshot.docs.map((element) => {
                name = element["name"],
                description = element["name"],
                photo = element["name"],
                minBidRate = element["minBidPrice"],
                minBidRate = getEndDate(element["date"] + element["time"]),
              });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print("dataTble Id :" + widget.tbleId);
    fetchProductsData();
    super.initState();
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
            title: Text('Details Products'),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Ink.image(
                        image: NetworkImage(
                          path.toString(),
                        ),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Name: ${name}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Description: ${description}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Min Bid Price: ${minBidRate}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "End Time: ${endDate} ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  String getEndDate(String date) {
    var returnString = '';
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm a');
    final today = formatter.format(now);
    final fromDate = formatter.parse(date);
    final toDate = formatter.parse(today);

    var days = toDate.difference(fromDate).inDays;
    var hour = toDate.difference(fromDate).inHours % 24;
    var minute = toDate.difference(fromDate).inMinutes % 60;
    if (minute > 0) {
      if (days < 1) {
        returnString = "Days: ${0} Hour: ${hour} Minute: ${minute}";
      } else {
        returnString = "Days: ${days} Hour: ${hour} Minute: ${minute}";
      }
    } else {
      returnString = "Complete";
    }

    return returnString;
  }
}
