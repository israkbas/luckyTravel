import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'kayıt_giris.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool _loggedIn = false;

  void _logout() {
    setState(() {
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 6, 56, 62),
                  Color.fromARGB(255, 24, 153, 170)
                ],
              ),
            ),
            child: Center(
                child: SingleChildScrollView(
              child: FadeInLeft(
                child: Container(
                  height: 300,
                  margin: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child:
                        _loggedIn ? _buildUserDetails() : _buildLoginMessage(),
                  ),
                ),
              ),
            ))));
  }

  Widget _buildLoginMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Kullanıcı girişi yapmadan üyelik bilgileri görüntülenemez !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 90,
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(13.0), // 30.0
          color: Colors.teal,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width.sign,
            onPressed: () {
              Get.offAll(() => LoginPage());
            },
            child: Text(
              'Giriş Yap',
              style: TextStyle(
                  backgroundColor: Colors.teal,
                  fontSize: 20,
                  fontFamily: 'comic-sans',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildUserDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Login').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data!.docs;
          if (documents.isNotEmpty) {
            final user = documents.first.data() as Map<String, dynamic>;
            final firstName = user['userName'].toString();
            final lastName = user['userSurname'].toString();
            final nickName = user['userNickname'].toString();
            final email = user['userMail'].toString();

            return Column(
              children: [
                CircleAvatar(radius: 100),
                Divider(),
                Text(
                  "Üyelik Bilgileri",
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 30),
                Text(
                  firstName,
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 20),
                Text(
                  lastName,
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 20),
                Text(
                  nickName,
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 20),
                Text(
                  email,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text(
                    'Çıkış Yap',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            );
          }
        } else if (snapshot.hasError) {
          return Text('Veriler alınırken bir hata oluştu.');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
