import 'package:crypto/View/dashboard.dart';
import 'package:crypto/View/login_signup/signup.dart';
import 'package:crypto/View/navBar.dart';
import 'package:flutter/material.dart';
import 'package:crypto/View/home.dart';
// import 'package:crypto/View/login_signup/singup.dart';
import 'package:crypto/widgets/button.dart';
import 'package:crypto/widgets/textInput.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
Future<bool> authenticateUserWithEmailAndPassword() async {

  try {
    // Sign in the user with email and password
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text,
    );
     
    // If sign-in is successful, you can perform additional actions here

    print('User signed in: ${userCredential.user!.email}');
    return true;
  } catch (e) {
    // Handle sign-in errors
    print('Failed to sign in: $e');
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 90, left: 36, right: 36, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 40),
                Stack(
                  children: [
                    Container(
                      width: 300,
                      // color: Colors.amber,
                      child: Column(
                        children: [
                          Text(
                            'CogniTrade',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 20),
                    Text(
                      "Welcome back you've",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      "been missed!",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade800,
                      ),
                    ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      
                      right: 30,
                      child: Image.asset("assets/image/cogni2.png",width: 40,))
                  ],
                ),
                
                SizedBox(height: 48),
                _buildForm(),
                SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade200,
                              Colors.grey.shade400
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                      ),
                    ),
                     Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
             Get.to(SignUp());         
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade300,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            //     SizedBox(height: 50),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         _buildSocialBox(
            //             FontAwesomeIcons.google, Colors.red.shade500),
            //         _buildSocialBox(FontAwesomeIcons.apple, Colors.black),
            //         _buildSocialBox(Icons.facebook, Colors.blue),
            //       ],
            //     ),
            //     SizedBox(height: 48),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Not a member? ',
            //           style: TextStyle(
            //             color: Colors.grey.shade700,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {
            //  Get.to(SignUp());         
            //           },
            //           child: Text(
            //             'Register now',
            //             style: TextStyle(
            //               color: Colors.blue.shade400,
            //             ),
            //           ),
            //         ),
            //       ],
            //     )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextInput(
            hint: 'Enter username',
            controller: usernameController,
          ),
          SizedBox(height: 16),
          TextInput(
            hint: 'Password',
            controller: passwordController,
            obscure: true,
            suffixIcon: FontAwesomeIcons.eyeSlash,
          ),
          // GestureDetector(
          //   onTap: () {
          //     if (_formKey.currentState!.validate()) {}
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 16),
          //     alignment: Alignment.topRight,
          //     child: Text(
          //       'Recover password',
          //       style: TextStyle(
          //         fontWeight: FontWeight.w600,
          //         color: Colors.grey.shade600,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 24,
          ),
          Button(
            label: 'Sign in',
            onTap: () async{
              
              if (_formKey.currentState!.validate()) {
                
                   bool a=await authenticateUserWithEmailAndPassword();
                   print(a);
                   if (a==true) {
                    print(1);
             Get.to(NavBar());    
                   } 
                   else {
                      ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Authentication failed. Please try again.'),
                  ),
                );
                                  _formKey.currentState!.reset();
                   }
                  
                               Get.to(NavBar());    
 
                
                    
                 }

            },
          ),
        ],
      ),
    );
  }

  Container _buildSocialBox(IconData icon, Color color) {
    return Container(
      width: 85,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 36,
          color: color,
        ),
      ),
    );
  }
}