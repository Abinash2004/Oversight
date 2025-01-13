import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Account/Login/code_screen.dart';
import 'package:finance_tracker/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String loginEmail = "";
  static String error = "";
  static bool isUserExist = false;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  bool isLoading = false;
  // String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: accentColor1,
        title: loginTitleText('FINANCE TRACKER'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            headingText('${MyApp.user} Login', true),
            headingText(selectSubHeading(),false),
            const SizedBox(height: 20),
      
            emailTextFormField(email),
            const SizedBox(height: 10),

            (LoginScreen.error.isEmpty) ? const SizedBox() : Text(LoginScreen.error,style: const TextStyle(color: Colors.redAccent,fontSize: 15)),
            const SizedBox(height: 10),
            
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {isLoading = true;});

                  if(email.text.isEmpty) {
                    setState(() {
                      LoginScreen.error = 'Email is Required';
                      isLoading = false;
                    });
                  } else {
                    String modifiedEmail = email.text.replaceFirst(RegExp(r'\.[^.]*$'), '');
                    await userCheck(modifiedEmail);
                    setState(() {
                      isLoading = false;
                    });
                    
                    if(LoginScreen.isUserExist) {
                      LoginScreen.error = "";
                      MyApp.email = email.text;
                      LoginScreen.loginEmail = email.text;
                      setState(() {isLoading = false;});
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const OtpScreen()));
                    }
                  } 
                },
                style: buttonStyle(),
                child: isLoading ? const SizedBox( height: 25, width: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3,valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) : buttonText('Proceed'),
              ),
            ),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                TextButton(
                  onPressed: () {setState(() {userSwitch(true);});},
                  child: Text(userSwitchText(true,context),
                    style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
                  ),
                ),
      
                loginTitleText('|'),
      
                TextButton(
                  onPressed: () {setState(() {userSwitch(false);});},
                  child: Text(userSwitchText(false,context),
                    style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}