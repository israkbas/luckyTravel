import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukcytravel/screens/register.dart';
import 'package:lukcytravel/screens/root.dart';
import 'package:lukcytravel/screens/services.dart';
import 'package:lukcytravel/utils/login_controller.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  LoginController loginController = Get.put(LoginController());

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
            child: FadeInLeft(
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
                      children: [
                        const SizedBox(height: 40.0),
                        luckTravelText(),
                        const SizedBox(height: 80.0),
                        emailField(),
                        const SizedBox(height: 10.0),
                        passwordField(),
                        const SizedBox(height: 28.0),
                        loginButton(),
                        const SizedBox(height: 30.0),
                        registerNowText(),
                        const SizedBox(height: 30.0),
                        gmailButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text luckTravelText() {
    return const Text(
      'Lucky Travel',
      style: TextStyle(
        color: Color.fromARGB(255, 6, 56, 62),
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }

  emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) return ('Lütfen Email Girin!');
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.mail,
          color: Colors.teal,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  bool obsController = true;
  passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obsController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) return ('Lütfen Şifre Girin!');
        if (value.length < 6) return ('Şifre Min 6 Karakter olabilir)');
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.teal,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obsController == true ? Icons.visibility : Icons.visibility_off,
            color: Colors.teal,
          ),
          onPressed: () {
            obsController == true
                ? setState(() {
                    obsController = false;
                  })
                : setState(() {
                    obsController = true;
                  });
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Şifre',
        hintStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  loginButton() {
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
                .signIn(emailController.text, passwordController.text)
                .then(
              (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Giriş Başarılı'),
                  ),
                );
                loginController.userUid.value = value.toString();
                Get.offAll(() => RootApp());
                /*    Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RootApp(),
                  ),
                ); */
              },
            );
          }
        },
        child: const Text(
          'Giriş Yap',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  gmailButton() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8.0), // 30.0
      color: Colors.teal,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          _authService.signInWithGoogle().then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Google İle Giriş Yapıldı')));
              Get.offAll(() => RootApp());
              /*  Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RootApp(),
                ),
              ); */
            },
          );
        },
        child: const Text(
          'Google ile Giriş Yap',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  registerNowText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Kayıtlı Değil Misin ?  ',
          style: TextStyle(fontSize: 15, fontFamily: 'comic-sans'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'comic-sans',
                color: Colors.teal,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
