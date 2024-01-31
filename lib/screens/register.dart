import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lukcytravel/screens/services.dart';

import 'kayıt_giris.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> pickImageFromGallery() async {
    final imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _selectedImage = File(imageFile.path);
      });

      // Firebase Storage'a fotoğrafı yükle
      String imageURL = await _uploadImageToFirebase(_selectedImage!);
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_image')
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
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SingleChildScrollView(
          child: FadeInRight(
            child: Container(
              margin: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_selectedImage != null)
                        Container(
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      _selectedImage == null
                          ? Container(
                              width: 150.0,
                              height: 150.0,
                              child: FloatingActionButton(
                                onPressed: pickImageFromGallery,
                                backgroundColor: Colors.teal,
                                child: const Icon(
                                  Icons.photo_library,
                                  size: 80,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20.0),
                      firstNameField(),
                      const SizedBox(height: 12.0),
                      lastNameField(),
                      const SizedBox(height: 12.0),
                      nickNameField(),
                      const SizedBox(height: 12.0),
                      emailField(),
                      const SizedBox(height: 12.0),
                      passwordField(),
                      const SizedBox(height: 12.0),
                      confirmPasswordField(),
                      const SizedBox(height: 18.0),
                      registerButton(),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

  firstNameField() {
    return TextFormField(
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) return ("İsim Boş Geçilemez");
        if (value.length < 3) return ("İsim Değeri Min. 3 Karakter Olmalı!");
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'İsim',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  lastNameField() {
    return TextFormField(
      controller: lastNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) return ("Soyisim Boş Geçilemez");
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Soyisim',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  nickNameField() {
    return TextFormField(
      controller: nickNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) return ("Kullanıcı Adı Boş Geçilemez");
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.perm_contact_cal, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Kullanıcı Adı',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) return ("Lütfen Email Girin!");
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Lütfen Email Girin");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) return ("Giriş için şifre gereklidir!");
        if (value.length < 6) return ("Şifre min 6 karakter olmalı");
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key, color: Colors.teal),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Şifre',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  confirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return "Şifreler Eşleşmedi !";
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.teal,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Şifre Doğrula',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  registerButton() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8.0), // 30.0
      color: Colors.teal,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _authService
                .createPerson(
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    passwordController.text,
                    nickNameController.text)
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Kayıt Başarılı Giriş Sayfasına Yönlendiriliyorsunuz.'),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            });
          }
        },
        child: const Text(
          'Kayıt Ol',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
