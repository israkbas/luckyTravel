import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../screen/detail_page.dart';
import 'custom_image.dart';

class ExploreItem extends StatefulWidget {
  final Map<String, dynamic> data;

  ExploreItem({required this.data});

  @override
  _ExploreItemState createState() => _ExploreItemState();
}

class _ExploreItemState extends State<ExploreItem> {
  late GestureTapCallback? onTap;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Blog').snapshots();
  final double raduis = 10;
  String imageUrl = "";
  var data;

  Future<void> imagestorage() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    // Resmi indirmek için Storage referansı oluşturun
    firebase_storage.Reference ref = storage
        .ref()
        .child('blog_resimler/${data["ulke"]}_${data["yazarIsim"]}.jpg');

    // Resmi indirin ve bellekte bir dize olarak alın
    String downloadUrl = await ref.getDownloadURL();

    setState(() {
      imageUrl = downloadUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    imagestorage(); // Resmi yükleme işlemini başlatmak için initState içinde loadImage fonksiyonunu çağırın
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir şeyler yanlış gitti !');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Yükleniyor");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailPage(doc: document.id),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 150,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(raduis)),
                  child: Stack(
                    children: [
                      Container(
                        child: CustomImage(
                          data["image"].toString(),
                          radius: raduis,
                          width: double.infinity,
                          height: double.infinity,
                        ),
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
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
    );
  }
}
