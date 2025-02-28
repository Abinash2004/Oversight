import 'package:finance_tracker/Screen/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Screen/home_screen.dart';
import 'package:finance_tracker/main.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final code = TextEditingController();
  bool isLoading = false;
  String error = '';
  bool isFirstTimeLogin = false;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        title: loginTitleText('OVERSIGHT'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0), // Height of the underline
          child: Container(
            color: accentColor2, // Change to your desired underline color
            height: 0.5, // Thickness of the underline
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            headingText('Enter Code', true),
            
            headingText('Submit verification code given by management for  ${MyApp.email}',false),
            const SizedBox(height: 20),
            
            pinPutOTP(code),
            SizedBox(height: screen.height * 0.005),
            
            Row(
              children: [

                Checkbox(
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return accentColor2; // Color when checked
                      }
                      return bgColor; // Default color when unchecked
                    },
                  ),
                  value: isFirstTimeLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      isFirstTimeLogin = value ?? false;
                    });
                  },
                ),

                
                Text('First Time Login',
                  style: textStyle(primaryTextColor, 15, FontWeight.w400, 1, 0.25),
                ),
              ],
            ),
            
            (error.isEmpty) ? const SizedBox() : Text(error, style: const TextStyle(color: Colors.redAccent, fontSize: 15)),
            SizedBox(height: screen.height * 0.015),
            
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {error = '';});

                  if (code.text.isEmpty) {
                    setState(() {
                      error = 'Verification code is required';
                      isLoading = false;
                    });
                  } else if (code.text.length < 6) {
                    setState(() {
                      error = 'Invalid verification code';
                      isLoading = false;
                    });
                  } else {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (isFirstTimeLogin) {
                        await auth.createUserWithEmailAndPassword(
                            email: LoginScreen.loginEmail, password: code.text);
                      } else {
                        await auth.signInWithEmailAndPassword(
                            email: LoginScreen.loginEmail, password: code.text);
                      }

                      setState(() {isLoading = false;});

                      // ignore: use_build_context_synchronously
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()));

                      // ignore: use_build_context_synchronously
                      snackbar("Successfully Logged In", context);
                      
                    } on FirebaseAuthException catch (e) {
                      if (e.message ==
                          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                        setState(() {
                          error = 'Network Problem';
                          isLoading = false;
                        });
                      } else if (e.message ==
                          'The email address is already in use by another account.') {
                        setState(() {
                          error = 'User Existed - Uncheck the checkbox.';
                          isLoading = false;
                        });
                      } else if (e.message ==
                          'The supplied auth credential is incorrect, malformed or has expired.') {
                        setState(() {
                          error = 'Incorrect Code';
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          error = e.message.toString();
                          isLoading = false;
                        });
                      }
                    }
                  }
                },
                style: buttonStyle(),
                child: isLoading ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 3,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white70)
                  )
                ) : buttonText('Submit'),
              ),
            ),
            
            TextButton(
              onPressed: () {Navigator.pop(context);},
              child: Text('Modify Email Address', style: textStyle(primaryTextColor, 15, FontWeight.w400, 1, 0.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
