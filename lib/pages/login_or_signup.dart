import 'package:bookmymovie/pages/loginpage.dart';
import 'package:bookmymovie/pages/signup.dart';
import 'package:flutter/material.dart';

class LoginAndSignup extends StatefulWidget {
  const LoginAndSignup({super.key}) ;

  @override
  State<LoginAndSignup> createState() => _LoginAndSignupState();
}

class _LoginAndSignupState extends State<LoginAndSignup> {
  bool islogin=true;
  void togglePage(){
    setState(() {
      islogin=!islogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(islogin){
      return LoginPage(onPressed:togglePage);
    }else{
      return SignUp(onPressed:togglePage);
    }
    return const Placeholder();
  }
}
