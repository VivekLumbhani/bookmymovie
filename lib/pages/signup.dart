import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final void Function()? onPressed;
  const SignUp({super.key, required this.onPressed}) ;
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  final _formKey=GlobalKey<FormState>();
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  bool isLoading=false;
  createUserWithEmailAndPassword()async{
    try {
      setState(() {
        isLoading=true;
      });
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      setState(() {
        isLoading=false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading=false;
      });
      if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('weak Password'),
            )
        );      } else if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email already exist'),
            )
        );
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignUp',style: TextStyle(color: Colors.white),),centerTitle: true,backgroundColor: Colors.blue,),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child:SingleChildScrollView(

          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
                TextFormField(
                  controller: _email,
                  validator: (text){
                    if(text==null || text.isEmpty){
                      return "Email can't be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Enter Email",border: OutlineInputBorder(),prefixIcon: Icon(Icons.lock),),
                ),
                TextFormField(
                  obscureText: true,
                  controller: _password,
                  validator: (text){
                    if(text==null || text.isEmpty){
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
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        createUserWithEmailAndPassword();
                      }
                    },
                    child:isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white,),)
                        : const Text('Register'),                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Aleady have an acc? ',style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                        onPressed: widget.onPressed
                        , child: Text('Login')),
                  ],
                ),
              ],
            ),
          ),
        )
        ),
      ),
    );
  }
}