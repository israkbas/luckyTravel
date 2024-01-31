import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class BlogEditorPage extends StatefulWidget {
  @override
  _BlogEditorPageState createState() => _BlogEditorPageState();
}

class _BlogEditorPageState extends State<BlogEditorPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  double _currentSliderValue = 1.0;
  File? _selectedImage;
  final _picker = ImagePicker();
  final TextEditingController _photoUrlController = TextEditingController();
  TextEditingController yazarIsmiController = TextEditingController();
  TextEditingController ulkeController = TextEditingController();
  TextEditingController sehirController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _konaklamaMaliyetController =
      TextEditingController();
  final TextEditingController _yolMaliyetController = TextEditingController();
  final TextEditingController _yemeIcmeController = TextEditingController();
  final TextEditingController _gunController = TextEditingController();
  final TextEditingController _ekstraController = TextEditingController();
  final TextEditingController _ekstraAController = TextEditingController();

  final TextEditingController _tasitController = TextEditingController();
  final TextEditingController _konaklamaController = TextEditingController();
  int otelIndex = 0;
  double _otelSliderValue = 1.0;
  DateTime tsdate = DateTime.now();
  List<DropdownMenuItem<String>> sehirList = [];
  List<DropdownMenuItem<String>> ulkeList = [];
/* 
  @override
  void initState() {
    readJsonData();
    super.initState();
  }

  Future<void> readJsonData() async {
    String jsonData = await rootBundle.loadString('assets/world-cities.json');
    List data = json.decode(jsonData);
    for (var i = 0; i < data.length; i++) {
      String ulke = data[i]["country"].toString();

      ulkeList.add(DropdownMenuItem(
        value: "${data[i]["country"]} - ${data[i]["subcountry"]}",
        child: Text("${data[i]["country"]} - ${data[i]["subcountry"]}"),
      ));
    }
    setState(() {
      ulkeList;
    });
  } */

  Future<void> fetchData() async {
    if (_titleController.text.isEmpty &&
        _descController.text.isEmpty &&
        _konaklamaMaliyetController.text.isEmpty &&
        _yolMaliyetController.text.isEmpty &&
        _gunController.text.isEmpty &&
        _ekstraController.text.isEmpty &&
        _photoUrlController.text.isEmpty &&
        ulkeController.text.isEmpty &&
        sehirController.text.isEmpty &&
        _yemeIcmeController.text.isEmpty) {
      print("Boş Bırakılamaz!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hücreler Boş Bırakılamaz!'),
        ),
      );
    } else {
      double konaklamaMaliyet =
          double.tryParse(_konaklamaMaliyetController.text) ?? 0.0;
      double yolMaliyet = double.tryParse(_yolMaliyetController.text) ?? 0.0;
      double ekstra = double.tryParse(_ekstraController.text) ?? 0.0;
      double yemeIcme = double.tryParse(_yemeIcmeController.text) ?? 0.0;
      int gun = int.tryParse(_gunController.text) ?? 0;

      double toplam = konaklamaMaliyet + yolMaliyet + ekstra + yemeIcme;

      double gunluk = toplam / gun;

      await firestore.collection("Blog").add({
        "ulke": ulkeController.text,
        "sehir": sehirController.text,
        "yazarIsim": yazarIsmiController.text,
        "photoUrl": _photoUrlController.text,
        "baslik": _titleController.text,
        "icerik": _descController.text,
        "konaklamaMaliyet": _konaklamaMaliyetController.text,
        "yolMaliyet": _yolMaliyetController.text,
        "gun": _gunController.text,
        "ekstra": _ekstraController.text,
        "ekstraAciklama": _ekstraAController.text,
        "yemeIcme": _yemeIcmeController.text,
        "seyahatSeviyesi": _currentSliderValue.toString(),
        "tasit": _tasitController.text,
        "konaklama": _konaklamaController.text,
        "otelKalite": _otelSliderValue.toString(),
        "toplamMaliyet": toplam.toString(),
        "gunlukMaliyet": gunluk.toStringAsFixed(2),
        "kayTarih": DateFormat(
          'd MMMM yyyy',
        ).format(tsdate).toString(),
      }).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Blog Oluşturuldu!'),
          ),
        );
      });
    }
  }

  void _uploadBannerImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      String imageURL = await _uploadImageToFirebase(_selectedImage!);
      _photoUrlController.text = imageURL; // photoUrl değerini güncelle
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName = '${ulkeController.text}_${yazarIsmiController.text}.jpg';
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('blog_resimler')
        .child(fileName);

    final uploadTask = firebaseStorageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == firebase_storage.TaskState.success) {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    throw Exception('Resmi Firebase Depolamaya yüklemekte hata oluştu.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Blog Yaz",
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.teal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: ulkeController,
                  decoration: InputDecoration(
                    hintText: 'Ülke',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.public),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: sehirController,
                  decoration: InputDecoration(
                    hintText: 'Şehir',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),

                TextField(
                  controller: yazarIsmiController,
                  decoration: InputDecoration(
                    hintText: 'Yazar Adı',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                // yeşil resim yükleme
                Center(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.teal /* .withOpacity(0.5) */,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        if (_selectedImage != null)
                          Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.upload, color: Colors.white),
                            onPressed: _uploadBannerImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Başlık',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    hintText: 'Yazmaya başla...',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  hint: const Text('Konaklama',
                      style: TextStyle(color: Colors.teal)),
                  items: const [
                    DropdownMenuItem(
                        child: Text("Ev", style: TextStyle(color: Colors.teal)),
                        value: "Ev"),
                    DropdownMenuItem(
                        child:
                            Text("Otel", style: TextStyle(color: Colors.teal)),
                        value: "Otel"),
                    DropdownMenuItem(
                        child:
                            Text("Çadır", style: TextStyle(color: Colors.teal)),
                        value: "Çadır"),
                  ],
                  onChanged: (value) {
                    _konaklamaController.text = value!;

                    setState(() {});
                    if (value.toString() == "Otel") {
                      otelIndex = 1;
                    }
                    // Şehir açılır menüsü işlevselliği
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.hotel),
                  ),
                ),
                otelIndex == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          const Text(
                            "Otel Sınıfı (1-2-3-4-5)",
                            style: TextStyle(color: Colors.teal),
                          ),
                          Slider(
                            value: _otelSliderValue,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: Colors.teal,
                            inactiveColor: Colors.tealAccent,
                            label: _otelSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _otelSliderValue = value;
                              });
                            },
                          ),
                        ],
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 16),
                TextField(
                  controller: _konaklamaMaliyetController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Konaklama Maliyeti',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.money),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  hint: const Text(
                    'Taşıt',
                    style: TextStyle(color: Colors.teal),
                  ),
                  style: TextStyle(color: Colors.teal),
                  items: const [
                    DropdownMenuItem(
                        child: Text("Otomobil",
                            style: TextStyle(color: Colors.teal)),
                        value: "Otomobil"),
                    DropdownMenuItem(
                        child:
                            Text("Tren", style: TextStyle(color: Colors.teal)),
                        value: "Tren"),
                    DropdownMenuItem(
                        child: Text("Hızlı Tren",
                            style: TextStyle(color: Colors.teal)),
                        value: "Hızlı Tren"),
                    DropdownMenuItem(
                        child:
                            Text("Uçak", style: TextStyle(color: Colors.teal)),
                        value: "Uçak"),
                    DropdownMenuItem(
                        child:
                            Text("Gemi", style: TextStyle(color: Colors.teal)),
                        value: "Gemi"),
                  ],
                  onChanged: (value) {
                    _tasitController.text = value!;
                    // Şehir açılır menüsü işlevselliği
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.flight),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _yolMaliyetController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Yol Maliyeti',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.money),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _yemeIcmeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Yeme-İçme Maliyeti',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.money),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _gunController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Gün Sayısı',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.money),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _ekstraController,
                  decoration: InputDecoration(
                    hintText: 'Ekstra Maliyetler',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.money),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _ekstraAController,
                  decoration: InputDecoration(
                    hintText: 'Ekstra Maliyetler Açıklama',
                    hintStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.edit_document),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 16),
                Text("Seyahat Kalitesi (Düşük: 1, Orta: 2, Yüksek: 3)",
                    style: TextStyle(color: Colors.teal)),
                Slider(
                  value: _currentSliderValue,
                  min: 1,
                  max: 3,
                  divisions: 2,
                  activeColor: Colors.teal,
                  inactiveColor: Colors.tealAccent,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () => fetchData(),
                  child: Text('Yayınla'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
