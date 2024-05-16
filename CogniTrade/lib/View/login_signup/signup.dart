// import 'package:flutter/material.dart';
// import 'package:crypto/widgets/button.dart';
// import 'package:crypto/widgets/textInput.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:get/get.dart';


// class SignUp extends StatefulWidget {
//   SignUp({Key? key}) : super(key: key);

//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.only(top: 30, left: 36, right: 36, bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 SizedBox(height: 40),
//                 Stack(
//                   children: [
//                     Container(
//                       width: 300,
//                       // color: Colors.amber,
//                       child: Column(
//                         children: [
//                           Text(
//                             'CogniTrade',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 28,
//                               color: Colors.grey.shade800,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                     Text(
//                       "Welcome back you've",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                     Text(
//                       "been missed!",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       top: 0,
                      
//                       right: 30,
//                       child: Image.asset("assets/image/cogni2.png",width: 40,))
//                   ],
//                 ),
                
//                 SizedBox(height: 48),
//                 _buildForm(),
//                 SizedBox(height: 48),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 2,
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.grey.shade200,
//                               Colors.grey.shade400
//                             ],
//                             begin: const FractionalOffset(0.0, 0.0),
//                             end: const FractionalOffset(0.5, 0.0),
//                             stops: [0.0, 1.0],
//                             tileMode: TileMode.clamp,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Or continue with',
//                       style: TextStyle(color: Colors.grey.shade700),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 2,
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.grey.shade400,
//                               Colors.grey.shade300,
//                             ],
//                             begin: const FractionalOffset(0.0, 0.0),
//                             end: const FractionalOffset(0.5, 0.0),
//                             stops: [0.0, 1.0],
//                             tileMode: TileMode.clamp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildSocialBox(
//                         FontAwesomeIcons.google, Colors.red.shade500),
//                     _buildSocialBox(FontAwesomeIcons.apple, Colors.black),
//                     _buildSocialBox(Icons.facebook, Colors.blue),
//                   ],
//                 ),
//                 SizedBox(height: 48),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Not a member? ',
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                     Text(
//                       'Register now',
//                       style: TextStyle(
//                         color: Colors.blue.shade400,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Form _buildForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           TextInput(
//             hint: 'Enter username',
//             controller: usernameController,
//           ),
//           SizedBox(height: 16),
//           TextInput(
//             hint: 'Password',
//             controller: passwordController,
//             obscure: true,
//             suffixIcon: FontAwesomeIcons.eyeSlash,
//           ),
//                     SizedBox(height: 16),

//           TextInput(
//             hint: 'Confirm Password',
//             controller: passwordController,
//             obscure: true,
//             suffixIcon: FontAwesomeIcons.eyeSlash,
//           ),
          
//           SizedBox(
//             height: 24,
//           ),
//           Button(
//             label: 'Sign Up',
//             onTap: () {
              
//               if (_formKey.currentState!.validate()) {
//              Get.toNamed('/home');         
//                  }

//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Container _buildSocialBox(IconData icon, Color color) {
//     return Container(
//       width: 85,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.white, width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: FaIcon(
//           icon,
//           size: 36,
//           color: color,
//         ),
//       ),
//     );
//   }
// }

import 'package:crypto/View/login_signup/login.dart';
import 'package:flutter/material.dart';
import 'package:crypto/widgets/button.dart';
import 'package:crypto/widgets/textInput.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


Future<void> _registerUser() async {
  print("1");
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text,
    );

    // User registration successful, add user data to Firestore
    // try {
       CollectionReference users=FirebaseFirestore.instance.collection("users");
    await users.doc(userCredential.user!.uid).set({
      'email': usernameController.text,
      'password': passwordController.text,
      'uid': userCredential.user!.uid,
      // 'cardNumber':0,
      'totalamount':0 ,
      // 'cvv':0,
      'liquidity':0,
      'Portfolio':0
    });
    // } catch (e) {
    //   print(e);
    // }
   

    // Navigate to the desired screen after successful registration
    print("User registration successful: ${userCredential.user!.uid}");
 
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(top: 90, left: 36, right: 36, bottom: 0),
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
                            "Register Now",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            "To trade with Cognitrade",
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
                      child: Image.asset(
                        "assets/image/cogni2.png",
                        width: 40,
                      ),
                    )
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
                      'Or',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(LoginScreen());
                      },
                      child: Text(
                        '  Sign in',
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
                SizedBox(height: 50),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     _buildSocialBox(
                //         FontAwesomeIcons.google, Colors.red.shade500),
                //     _buildSocialBox(FontAwesomeIcons.apple, Colors.black),
                //     _buildSocialBox(Icons.facebook, Colors.blue),
                //   ],
                // ),
                // SizedBox(height: 48),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Not a member? ',
                //       style: TextStyle(
                //         color: Colors.grey.shade700,
                //       ),
                //     ),
                //     Text(
                //       'Register now',
                //       style: TextStyle(
                //         color: Colors.blue.shade400,
                //       ),
                //     ),
                //   ],
                // )
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
          // SizedBox(height: 16),
          // TextInput(
          //   hint: 'Confirm Password',
          //   controller: passwordController,
          //   obscure: true,
          //   suffixIcon: FontAwesomeIcons.eyeSlash,
          // ),
          SizedBox(
            height: 24,
          ),
          Button(
            label: 'Sign Up',
            onTap: () async{
              if (_formKey.currentState!.validate()) {
               await _registerUser();

      Get.to(LoginScreen());
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
