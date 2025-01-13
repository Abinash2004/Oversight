import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:intl/intl.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var date = "";
  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.dark(),child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
        date = DateFormat('dd / MM / yyyy').format(selectedDate!);
      });
    }
  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: accentColor1,
        leading: leadingBackButton(context),
        title: appBarTitleText('Add New Teacher'),
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
                  height: screen.width * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 2),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(children: [
                      Text("Date : \t$date",style: textStyle(
                                  Colors.white70, 20, FontWeight.w500, 1, 0.25),),
                      IconButton(onPressed: () => _selectDate(context),icon: const Icon(Icons.calendar_month, color: Colors.white60,size: 25))
                    ]
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
                            databaseRef
                                .child('Teacher')
                                .child(email.text
                                    .replaceFirst(RegExp(r'\.[^.]*$'), ''))
                                .set({
                              'Name': name.text,
                              'Email': email.text,
                              'Phone Number': phone.text,
                              'Joining Date': date
                            }).then((value) {
                              setState(() {
                                isLoading = false;
                                name = TextEditingController(text: '');
                                phone = TextEditingController(text: '');
                                email = TextEditingController(text: '');
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
