import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  var name = TextEditingController();
  var email = TextEditingController();
  var code = TextEditingController();
  var phone = TextEditingController();

  String std = '1';
  String day = DateTime.now().day.toString();
  String month = 'January';
  String year = DateTime.now().year.toString();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: accentColor1,
        leading: leadingBackButton(context),
        title: appBarTitleText('Add New Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                
                addTextFormField('Name', name,
                    const Icon(Icons.person, color: Colors.white54), true),
                SizedBox(height: screen.height * 0.025),
                
                addTextFormField('Phone Number', phone,
                    const Icon(Icons.phone, color: Colors.white54), false),
                SizedBox(height: screen.height * 0.025),
                
                addTextFormField('Email', email,
                    const Icon(Icons.email, color: Colors.white54), true),
                SizedBox(height: screen.height * 0.025),
                
                Container(
                  height: screen.width * 0.165,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 2),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Class\t:',
                            style: textStyle(
                                Colors.white70, 20, FontWeight.w500, 1, 0.25),
                          ),
                        ),
                        SizedBox(width: screen.width * 0.05),
                        DropdownButton<String>(
                          value: std,
                          items: [
                            for (int i = 1; i < 13; i++)
                              DropdownMenuItem<String>(
                                  value: i.toString(),
                                  child: Text(i.toString(),
                                      style: textStyle(Colors.white70, 17,
                                          FontWeight.w500, 1, 0.25))),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              std = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screen.height * 0.025),
                Container(
                  height: screen.width * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 2),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Joining Date',
                            style: textStyle(
                                Colors.white70, 20, FontWeight.w500, 1, 0.25),
                          ),
                        ),
                        SizedBox(height: screen.height * 0.015),
                        Row(
                          children: [
                            DropdownButton<String>(
                              value: day,
                              items: [
                                for (int i = 1; i < 32; i++)
                                  DropdownMenuItem<String>(
                                      value: i.toString(),
                                      child: Text(i.toString(),
                                          style: textStyle(Colors.white70, 17,
                                              FontWeight.w500, 1, 0.25))),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  day = newValue!;
                                });
                              },
                            ),
                            SizedBox(width: screen.width * 0.05),
                            DropdownButton<String>(
                              value: month,
                              items: [
                                for (int i = 0; i < 12; i++)
                                  DropdownMenuItem<String>(
                                      value: months[i],
                                      child: Text(months[i],
                                          style: textStyle(Colors.white70, 17,
                                              FontWeight.w500, 1, 0.25))),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  month = newValue!;
                                });
                              },
                            ),
                            SizedBox(width: screen.width * 0.025),
                            DropdownButton<String>(
                              value: year,
                              items: [
                                for (int i = 2020;
                                    i <= DateTime.now().year.toInt();
                                    i++)
                                  DropdownMenuItem<String>(
                                      value: i.toString(),
                                      child: Text(i.toString(),
                                          style: textStyle(Colors.white70, 17,
                                              FontWeight.w500, 1, 0.25))),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  year = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screen.height * 0.025),
                SizedBox(
                    height: screen.height * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: buttonStyle(),
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final databaseRef =
                                FirebaseDatabase.instance.ref().child('User');
                            databaseRef.child('Student').child(email.text.replaceFirst(RegExp(r'\.[^.]*$'), '')).set({
                              'Name': name.text,
                              'Email': email.text,
                              'Phone Number': phone.text,
                              'Joining Date': '$day $month $year',
                              'Class': std,
                            }).then((value) {
                              setState(() {
                                isLoading = false;
                                name = TextEditingController(text: '');
                                phone = TextEditingController(text: '');
                                email = TextEditingController(text: '');
                              });
                              showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (context) {
                                    return memberAddedBox(context, name, phone, email);
                                  });
                            });
                          } on FirebaseAuthException catch (error) {
                            print(error);
                          }
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white70)))
                          : buttonText('Save'),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
