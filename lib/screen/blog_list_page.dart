import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lukcytravel/screen/detail_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lukcytravel/widgets/round_textbox.dart';

import '../widgets/custom_image.dart';

class BlogListPage extends StatefulWidget {
  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance.collection('Blog').snapshots();
  final double raduis = 20;
  String imageUrl = "";

  var data;

/*   Future<void> imagestorage() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    // Resmi indirmek için Storage referansı oluşturun
    firebase_storage.Reference ref = storage.ref().child(imagePath!);

    // Resmi indirin ve bellekte bir dize olarak alın
    String downloadUrl = await ref.getDownloadURL();

    setState(() {
      imageUrl = downloadUrl;
    });
  } */
  /*  Future<void> getImageUrl(String image) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref = storage.ref().child(image);
    var imageEnd = await ref.getDownloadURL();
    setState(() {
      imageUrl = imageEnd;
    });
  } */
  Future<String> getImageUrl(String imagePath) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('blog_resimler/$imagePath');
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: RoundTextBox(
                hintText: "Bul",
                prefixIcon: Icon(Icons.search, color: Color(0xFF3E4249)),
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('Blog').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data!.docs;

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String imagePath = data['ulke'].toString() +
                        "_" +
                        data['yazarIsim'].toString() +
                        ".jpg";

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(doc: document.id),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 350,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(raduis)),
                        child: Stack(
                          children: [
                            FutureBuilder<String>(
                              future: getImageUrl(imagePath),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                String imageUrl = snapshot.data!;

                                return CustomImage(
                                  imageUrl,
                                  radius: raduis,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              },
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(raduis),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(.5),
                                        Colors.white.withOpacity(.01),
                                      ])),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['baslik'].toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/marker.svg",
                                        width: 15,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data["ulke"].toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        data["sehir"].toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/tl-svgrepo-com.svg",
                                        width: 15,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Toplam Maliyet:  " +
                                            data["toplamMaliyet"] +
                                            " TL".toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset(
                                        "assets/icons/calendar-clock-svgrepo-com.svg",
                                        width: 15,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Seyahat Süresi:  " +
                                            data["gun"] +
                                            " Gün".toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
