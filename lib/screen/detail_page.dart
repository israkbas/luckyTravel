import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DetailPage extends StatefulWidget {
  DetailPage({super.key, this.doc});
  String? doc;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLiked = false;
  int _likeCount = 0;
  var isPressed = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var data;
  String imageUrl = "";

  Future<void> loadImage() async {
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

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      _likeCount++;
    });
  }

  //mainImage
  Widget mainImageWidget(height) => Container(
        height: height / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              IconButton(
                icon: (isPressed)
                    ? Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 28,
                      )
                    : Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 28,
                      ),
                onPressed: () {
                  setState(() {
                    if (isPressed == true) {
                      isPressed = false;
                    } else {
                      isPressed = true;
                    }
                  });
                },
              )
            ],
          ),
        ),
      );

  //Bottom Sheet Content

  Widget bottomContent(height, width) => Container(
        margin: EdgeInsets.only(top: height / 20),
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Category
              Row(
                children: [
                  Text(
                    data["ulke"].toUpperCase().toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[400]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    data["sehir"].toUpperCase().toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[200]),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              //Title
              Text(
                data["baslik"] /* "İtalya'da Nereye  Gitmeliyiz ?" */,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),

              const SizedBox(
                height: 12,
              ),

              //like and duration
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    data["kayTarih"],
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: _toggleLike,
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.thumb_up_alt : Icons.thumb_up,
                          color: _isLiked ? Colors.teal : Colors.grey,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _likeCount.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              //Profile Pic
              Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/2815428.png"),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    data["yazarIsim"].toUpperCase().toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              //Paragraph
              Text(
                data["icerik"],
                style: TextStyle(
                    color: Colors.black54, fontSize: 16.5, height: 1.4),
                textAlign: TextAlign.left,
                maxLines: 8,
              ),

              SizedBox(height: 35),
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  Text(
                    "  ${data["gun"]} (gün)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.restaurant),
                  Text(
                    "  ${data["yemeIcme"]} TL",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.flight),
                  Text(
                    "  ${data["yolMaliyet"]} TL",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.hotel),
                  Text(
                    "   ${data["konaklamaMaliyet"]} TL",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: Column(children: [
                  Text(
                    "TOPLAM MALİYET (TL) ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data["toplamMaliyet"],
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
              SizedBox(height: 30),
              Center(
                child: Column(children: [
                  Text(
                    "GÜNLÜK MALİYET  ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data["gunlukMaliyet"],
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    getData().then((value) {
      loadImage();
    });

    super.initState();
  }

  Future<void> getData() async {
    data = await firestore.collection("Blog").doc(widget.doc!.toString()).get();
    setState(() {
      data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                //Main Image
                mainImageWidget(height),

                //Bottom Sheet
                Container(
                  //Bottom Sheet Dimensions
                  margin: EdgeInsets.only(top: height / 2.3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),

                  child: bottomContent(height, width),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
