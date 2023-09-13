import 'package:bookmymovie/pages/home.dart';
import 'package:bookmymovie/pages/login_or_signup.dart';
import 'package:bookmymovie/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context,AsyncSnapshot<User?>snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }else{
              if(snapshot.hasData){
                return home();
              }else{
                return LoginAndSignup();
              }
            }
          },
      ),
    );
  }
}
