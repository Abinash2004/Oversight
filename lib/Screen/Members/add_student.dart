import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:intl/intl.dart';

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
  String date= "";
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
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
                    const Icon(Icons.person, color: primaryTextColor), true),
                SizedBox(height: screen.height * 0.025),
                
                addTextFormField('Phone Number', phone,
                    const Icon(Icons.phone, color: primaryTextColor), false),
                SizedBox(height: screen.height * 0.025),
                
                addTextFormField('Email', email,
                    const Icon(Icons.email, color: primaryTextColor), true),
                SizedBox(height: screen.height * 0.025),
                
                Container(
                  height: screen.width * 0.165,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 1),
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
                  height: screen.width * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 1),
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
                        setState(() {isLoading = true;});
                        final databaseRef = FirebaseDatabase.instance.ref().child('User');
                        databaseRef.child('Student').child(email.text.replaceFirst(RegExp(r'\.[^.]*$'), '')).set({
                          'Name': name.text,
                          'Email': email.text,
                          'Phone Number': phone.text,
                          'Joining Date': date.toString(),
                          'Class': std,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                            name = TextEditingController(text: '');
                            phone = TextEditingController(text: '');
                            email = TextEditingController(text: '');
                          });
                          name = TextEditingController(text: '');
                          phone = TextEditingController(text: '');
                          email = TextEditingController(text: '');
                          // ignore: use_build_context_synchronously
                          snackbar("Successfully Added", context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          
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
