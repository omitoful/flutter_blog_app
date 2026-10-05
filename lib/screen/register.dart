import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constant.dart';
import 'package:flutter_blog_app/model/api_response.dart';
import 'package:flutter_blog_app/model/user.dart';
import 'package:flutter_blog_app/screen/homepage.dart';
import 'package:flutter_blog_app/screen/login.dart';
import 'package:flutter_blog_app/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirm = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(txtName.text, txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(' token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), centerTitle: true),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: txtName,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: inputDecoration('Name'),
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: inputDecoration('Email'),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              validator: (val) => val!.isEmpty ? 'Require at least 6 words' : null,
              decoration: inputDecoration('Password'),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtConfirm,
              obscureText: true,
              validator: (val) => val != txtPassword.text ? 'Password not match' : null,
              decoration: inputDecoration('Confirm Password'),
            ),
            SizedBox(height: 15),
            (loading)
                ? Center(child: CircularProgressIndicator())
                : textButton('Register', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _registerUser();
                      });
                    }
                  }),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  child: Text('Login', style: TextStyle(color: Colors.blue)),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
