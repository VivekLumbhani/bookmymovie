import 'package:bookmymovie/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onPressed;

  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('wrong User'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('wrong password for user'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child:SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
            children: [
              Image.asset('images/profile.png', width: 100, height: 100,),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: OverflowBar(
                  overflowSpacing: 20,
                  children: [
                    TextFormField(
                      controller: _email,

                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Email can't be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _password,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Password can't be empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Enter Password",border: OutlineInputBorder(),prefixIcon: Icon(Icons.lock),),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // background color
                          foregroundColor: Colors.white, // text color
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signInWithEmailAndPassword();
                          }
                        },
                        child: isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text('Login'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('already have an acc? ',style: TextStyle(fontSize: 16),
                        ),
                        TextButton(onPressed: () {
                          widget.onPressed?.call(); // Call the onPressed function
                          print('object');
                        }, child: Text('signUp')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

        ),
      ),
    );
  }
}
