import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/messages.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _MyAppState();
}

class _MyAppState extends State<loginPage> {

  SnackBar _snackBar = new SnackBar(content: Text('Successfully Logged in'));
  SnackBar _snackBar2 = new SnackBar(content: Text('Oops, Something went wrong!'));

  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<bool> signIn() async{
      // final AuthResult
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        return true;
    }

    Future<void> showSB() async {

      if(await signIn()){
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(_snackBar2);
      }

    }

    void dispose(){
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(Icons.favorite),

              SizedBox(height: 10,),
              Image.asset('assets/images/Logo.jpeg'),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: (
                    TextFormField(
                      validator: (value){
                        if(value == null){
                          print("Error");
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),

                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                          ),

                          filled: true, fillColor: Color(0xFFEFEBE9),

                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEFEBE9)),
                              borderRadius: BorderRadius.circular(20)
                          ),

                          hintText: 'Email',

                          contentPadding: EdgeInsets.all(18)),

                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: (
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true, fillColor: Color(0xFFEFEBE9),

                          prefixIcon: Icon(Icons.lock),

                          labelStyle:
                          TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',

                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Password',
                          contentPadding: EdgeInsets.all(18)
                      ),
                    )
                ),
              ),

              // SizedBox(
              //   height: 10,
              // ),

              Container(
                height: 50,
                width: 400,
                child: ButtonTheme(
                    child: ElevatedButton(
                        onPressed: signIn,
                      //onTap: signIn,
                        child: const Text(style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat'
                        ),
                            'Sign In'),

                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          shape: StadiumBorder(),

                        )
                    ),
                ),
              ),

              //TextButton(onPressed: () {}, child: const Text('Sign Up')),

              SizedBox(
                height: 40,
              ),

              // Text('Don\'t have an account?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                      'Don\'t have an account?'),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => signup()));
                    },
                    child: Text(' Sign Up', style: TextStyle(color: Colors.lightGreen),),
                  )
                ],
              ),

              SizedBox(
                height: 15,
              ),


            ],
          ),
        ),
      ),
    );
  }

}
