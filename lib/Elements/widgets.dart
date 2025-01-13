import 'package:flutter/material.dart';
import 'package:finance_tracker/Screen/Account/account_screen.dart';
import 'package:finance_tracker/Screen/Account/edit_account.dart';
import 'package:finance_tracker/Screen/Members/add_student.dart';
import 'package:finance_tracker/Screen/Members/add_teacher.dart';
import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Screen/Monthly%20Collection/fees_collection.dart';
import 'package:finance_tracker/Screen/Monthly%20Collection/salary_collection.dart';
import 'package:finance_tracker/main.dart';
import 'package:finance_tracker/Screen/Members/member_list.dart';
import 'package:finance_tracker/Screen/Payment/payment.dart';
import 'package:finance_tracker/Screen/Payment/payment_history.dart';
import 'package:pinput/pinput.dart';

//------------------------------------------------
// ---------------Global Widgets------------------
//------------------------------------------------

const accentColor1 = Color.fromARGB(255, 0, 90, 100);
const accentColor2 = Color.fromARGB(255, 0, 130, 150);
const widgetColor = Color.fromARGB(255, 30, 30, 30);

//Global Text Style
TextStyle textStyle(var color, double size, var fontWeight, double lspacing, double wspacing) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontWeight: fontWeight,
    letterSpacing: lspacing,
    wordSpacing: wspacing
  );
}

// Text for button
Widget buttonText(String text) {
  return Center(
    child: Text(text,
      style: textStyle(Colors.white70, 20, FontWeight.w500, 0.3, 0.25),
    ),
  );
}

// Style for Button in login screen
ButtonStyle buttonStyle() {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => states.contains(WidgetState.pressed) ? null : accentColor1),
  );
}

// Global App Bar back button
Widget leadingBackButton(context) {
  return IconButton(
    onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,color: Colors.white));
}

//------------------------------------------------
//-----------------Login Widgets------------------
//------------------------------------------------

// Text for title in app bar
Widget loginTitleText(String text) {
  return Center(
    child: Text(text,
      style: textStyle(Colors.white, 20, FontWeight.w500, 2.5, 5),
    ),
  );
}

// text for heading in login screen
Widget headingText(String text, bool isheading) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(text,
      style: isheading ? 
      textStyle(Colors.white70, 35, FontWeight.w500, 1, 0.25):
      textStyle(Colors.white70, 15, FontWeight.w300, 1, 0.25),
    ),
  );
}

// Phone Number text field in login screen 
Widget emailTextFormField(var email) {

  var defaultBorder = const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      );

  return TextField(

    controller: email,
    keyboardType: TextInputType.emailAddress,
    cursorColor: accentColor2,
    style: textStyle(Colors.white70, 20, FontWeight.w400, 0, 0),

    decoration: InputDecoration(
      
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      filled: true,
      fillColor: const Color.fromARGB(255, 50, 50, 50),
      prefixIcon: const Icon(Icons.mail_rounded, color: Colors.white54),
      
      labelText: 'Email',
      labelStyle: textStyle(Colors.white54, 20, FontWeight.w500, 0.5, 0.25),
      floatingLabelStyle: textStyle(accentColor2, 23, FontWeight.w500, 0.3, 0.25),
      enabledBorder: defaultBorder,
      focusedBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
    ),
  );
}

// User switch button in login screen
Widget loginTextButton(bool isleft, var context) {
  return TextButton(
    onPressed: () {userSwitch(isleft);},
    child: Text(userSwitchText(isleft,context),
      style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
    ),
  );
}

// OTP recieving widget in OTP Screen
Pinput pinPutOTP(var otpCode) {
  final defaultPinTheme = PinTheme(
      width: 50,height: 50,
      textStyle: textStyle(Colors.white70, 20, FontWeight.w500, 0.3, 0.25),
      decoration: BoxDecoration(
        color: widgetColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: accentColor1,width: 2.5),
      borderRadius: BorderRadius.circular(10),
    );

  return Pinput( 
    length: 6,
    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: focusedPinTheme,
    controller: otpCode,
    showCursor: true,
  );
}

//-----------------------------------------------
//-------------Home Screen Widgets---------------
//-----------------------------------------------

// title text for home screen
Widget appBarTitleText(String text) {
  return Text(text, style: const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600
  ));
}

//App Bar for Home Screen
AppBar homeScreenAppBar(var context){
  return AppBar(
    // toolbarHeight: 75,
    title: appBarTitleText("Dashboard"),
    backgroundColor: accentColor1,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        onPressed: () {
          AccountScreen.user = MyApp.user;
          AccountScreen.name = MyApp.name;
          AccountScreen.email = MyApp.email;
          AccountScreen.phoneNumber = MyApp.phoneNumber;
          AccountScreen.joiningDate = MyApp.joiningDate;
          AccountScreen.std = MyApp.grade;
          AccountScreen.isLogOut = true;
          Navigator.push(context,MaterialPageRoute(builder:(context) => const AccountScreen()));
        },
        icon: const Icon(Icons.account_circle,size: 40),
      ),
    ],
  );
}

Widget homeScreenHeading(String text)  {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(text,style: textStyle(Colors.white70, 25, FontWeight.w500, 2, 0.3)),
    );
}

// Monthly Collection Widget 
Widget monthlyCollectionBox(var screen,String text, var context) {
  return SizedBox(
    height: screen.width*0.45,
    width: screen.width*0.425,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => widgetColor),
      ),
      onPressed: () {
        if(text == 'Salary') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SalaryCollection()));
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FeesCollection()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 7.5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(text,
                style: textStyle(Colors.white70, 25, FontWeight.w500, 0.5, 0),
              ),
            ),
            SizedBox(height: screen.height*0.022),
            const Icon(Icons.currency_rupee_rounded,size: 50,color: Color.fromARGB(255, 0, 130, 150)),
            SizedBox(height: screen.height*0.022),
            Align(
              alignment: Alignment.bottomLeft,child: Text('Monthly',style: textStyle(Colors.white70, 15, FontWeight.w300, 0.5, 0))),
          ],
        ),
      )
    ),
  );
}

//Select member and view information
Widget memberListContainer(var screen,String text, var context) {
  return SizedBox(
    height: screen.height*0.06,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        )),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => widgetColor),
      ),
      onPressed: () {
        if(text == 'Admin Information') {
          MemberList.user = 'Admin';
          Navigator.push(context,MaterialPageRoute(builder:(context) => const MemberList()));
        }
        else if(text == 'Teacher Information') {
          MemberList.user = 'Teacher';
          Navigator.push(context,MaterialPageRoute(builder:(context) => const MemberList()));
        }
        else {
          MemberList.user = 'Student';
          Navigator.push(context,MaterialPageRoute(builder:(context) => const MemberList()));
        }

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.person_rounded,color: accentColor2,size: 25),
          SizedBox(width: screen.width*0.05),
          Text(text,
            style: textStyle(Colors.white70, 17, FontWeight.w400, 1, 0.3),
          )
        ],
      )
    ),
  );
}

//Add a teacher or student widget
Widget addTeacherStudentContainer(context,screen, text) {
  return SizedBox(
    height: screen.height*0.075,
    width: screen.width*0.425,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        )),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => widgetColor),
      ),
      onPressed: () {
        if(text == 'Teacher') {
          Navigator.push(context,MaterialPageRoute(builder:(context) => const AddTeacherScreen()));
        }
        else {
          Navigator.push(context,MaterialPageRoute(builder:(context) => const AddStudentScreen()));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.add,color: accentColor2,size: 25),
          SizedBox(width: screen.width*0.025),
          Text(text,
            style: textStyle(Colors.white70, 17, FontWeight.w400, 1, 0),
          ),
        ],
      )
    ),
  );
}

// View Salary or Fees History Container
Widget paymentHistoryContainer(var screen,String text, var context) {
  return SizedBox(
    height: screen.height*0.06,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        )),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => widgetColor),
      ),
      onPressed: () {
        PaymentHistory.phoneNumber = MyApp.phoneNumber;
        PaymentHistory.user = MyApp.user;
        Navigator.push(context,MaterialPageRoute(builder:(context) => const PaymentHistory()));

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.history,color: accentColor2),
          SizedBox(width: screen.width*0.05),
          Text(text,
            style: textStyle(Colors.white70, 17, FontWeight.w400, 1, 0.3),
          )
        ],
      )
    ),
  );
}

//-----------------------------------------------
//-----------Account Screen Widgets--------------
//-----------------------------------------------

AppBar accountScreenAppBar(context) {
  return AppBar(
    backgroundColor: accentColor1,
    leading: IconButton(
    onPressed: () {
      AccountScreen.user = '';
      AccountScreen.name = '';
      AccountScreen.phoneNumber = '';
      AccountScreen.joiningDate = '';
      AccountScreen.std = '';
      AccountScreen.picture = '';
      AccountScreen.isLogOut = false;
      Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back,color: Colors.white)),
    title: appBarTitleText('Account Information'),
  );
}

//Account Name widget 
Widget accountName(text) {
  return Text(text,
  textAlign: TextAlign.center,
    style: textStyle(Colors.white70, 25, FontWeight.w500, 2, 0.25),
  );
}

//Account details
Widget accountDetails(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(text,
      style: textStyle(Colors.white70, 17, FontWeight.w500, 0.5, 0.25),
    ),
  );
}

//-----------------------------------------------
//---------Add Member Screen Widgets-------------
//-----------------------------------------------


Widget addTextFormField(var text,var controller, var icon, bool isName) {

  var defaultBorder = const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      );

  return TextFormField(
    validator: isName?validateName:validatePhone,
    controller: controller,
    keyboardType: isName?TextInputType.name: TextInputType.phone,
    cursorColor: accentColor2,
    style: isName?textStyle(Colors.white70, 20, FontWeight.w400, 2, 0.25) :textStyle(Colors.white70, 22, FontWeight.w400, 10, 0.25),

    decoration: InputDecoration(
      
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      filled: true,
      fillColor: const Color.fromARGB(255, 40, 40, 40),
      prefixIcon: icon,
      errorStyle: textStyle(Colors.redAccent, 15, FontWeight.w500, 0.5, 0.25),
      labelText: text,
      labelStyle: textStyle(Colors.white54, 20, FontWeight.w500, 0.5, 0.25),
      floatingLabelStyle: textStyle(accentColor2, 23, FontWeight.w500, 0.3, 0.25),
      enabledBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2)
      ),
      errorBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
      focusedErrorBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
      focusedBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
    ),
  );
}

//-----------------------------------------------
//---------Member List Screen Widgets------------
//-----------------------------------------------


// List Tile Title
Widget memberListTitle(String text) {
  return Text(text, 
    style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25)
  );
}

// List Tile Sub Title
Widget memberListSubTitle(String text) {
  return Text(text, 
    style: textStyle(Colors.white30, 15, FontWeight.w500, 1, 0.25)
  );
}

//Icon Button for Operation of Member Details
Widget memberListIconButton(var context, var screen, var icon, var databaseRef, String name, String phoneNumber, String email, String joiningDate, String std,String task) {
  return IconButton(
    onPressed: () async {
      if (task == 'Delete') {
        await deletAccount(context, screen, databaseRef, name, email);
      }

      else if (task == 'Payment History') {
        PaymentHistory.phoneNumber = phoneNumber;
        PaymentHistory.user = MemberList.user;
        PaymentHistory.name = name;
        PaymentHistory.joiningDate = joiningDate;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentHistory()));
      }
      else if(task == 'Payment') {
        PaymentScreen.user = MemberList.user;
        PaymentScreen.name = name;
        PaymentScreen.phoneNumber = phoneNumber;
        (MemberList.user == 'Student') ? PaymentScreen.std = std : null;
        Navigator.push(context,MaterialPageRoute(builder:(context) => const PaymentScreen()));
      }
      else if(task == 'Edit Account') {
        EditAccountScreen.editUser = MemberList.user;
        EditAccountScreen.name = name;
        EditAccountScreen.email = email;
        EditAccountScreen.phoneNumber = phoneNumber;
        (MemberList.user != 'Admin') ? EditAccountScreen.joiningDate = joiningDate : null;
        EditAccountScreen.std = std;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditAccountScreen()));
      }
    },
    icon: icon,
  );
}

// Text for Operation on Member details
Widget memberListText(String text) {
  return Text(text,
  textAlign: TextAlign.center,
  style: textStyle(Colors.white70, 12, FontWeight.w300, 0.5, 0.25),);
}

//-----------------------------------------------
//------------Payment Screen Widgets-------------
//-----------------------------------------------

// payment screen app bar widget
AppBar paymentScreenAppBar(context,String text) {
  return AppBar(
    backgroundColor: accentColor1,
    leading: IconButton(
    onPressed: () {
      AccountScreen.name = '';
      AccountScreen.phoneNumber = '';
      Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back,color: Colors.white)),
    title: appBarTitleText(text),
    actions: [
      AccountScreen.isLogOut ? IconButton(
        padding: const EdgeInsets.all(20),
        onPressed: () {
          logoutAccount(context);
        },
        icon: const Icon(Icons.logout,color: Colors.white),
      ): const Text(''),
    ],
  );
}

// Payment Screen Text Form Field 
Widget paymentTextFormField(var text,var controller, var icon) {

  var defaultBorder = const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      );

  return TextFormField(
    validator: validateAmount,
    controller: controller,
    keyboardType: TextInputType.number,
    cursorColor: accentColor2,
    style: textStyle(Colors.white70, 22, FontWeight.w400, 10, 0.25),

    decoration: InputDecoration(
      
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      filled: true,
      fillColor: const Color.fromARGB(255, 40, 40, 40),
      prefixIcon: icon,
      errorStyle: textStyle(Colors.redAccent, 15, FontWeight.w500, 0.5, 0.25),
      labelText: text,
      labelStyle: textStyle(Colors.white54, 20, FontWeight.w500, 0.5, 0.25),
      floatingLabelStyle: textStyle(accentColor2, 23, FontWeight.w500, 0.3, 0.25),
      enabledBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2)
      ),
      errorBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
      focusedErrorBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
      focusedBorder: defaultBorder.copyWith(
        borderSide: const BorderSide(color: accentColor2,style: BorderStyle.solid,width: 2),
      ),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(var text, var context) {
  return  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      content: Center(
        child: Text(text,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 22,
            fontWeight: FontWeight.w500
          ),
        ),
      )
    )
  );
}