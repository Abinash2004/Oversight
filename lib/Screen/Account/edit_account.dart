import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:intl/intl.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});
  static String editUser = '';
  static String name = '';
  static String email = '';
  static String phoneNumber = '';
  static String joiningDate = '';
  static String std = '';

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  var name = TextEditingController(text: EditAccountScreen.name);
  String std = EditAccountScreen.std;
  String day = DateTime.now().day.toString();
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
        EditAccountScreen.joiningDate = DateFormat('dd / MM / yyyy').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: accentColor1,
        title: appBarTitleText('Edit ${EditAccountScreen.editUser}'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50,left: 25,right: 25),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
        
                SizedBox(height: screen.height*0.025),
                (EditAccountScreen.editUser != 'Admin') ? addTextFormField('Name',name,const Icon(Icons.person, color: Colors.white54),true) : const SizedBox(),
                SizedBox(height: screen.height*0.025),

                (EditAccountScreen.editUser == 'Student') ? Container(
                  height: screen.width*0.165,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widgetColor,
                    border: Border.all(color: accentColor2,width: 2),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Class\t:',
                            style: textStyle(Colors.white70, 20, FontWeight.w500, 1, 0.25),
                          ),
                        ),
                        SizedBox(width: screen.width*0.05),
                        DropdownButton<String>(
                          value: std,
                          items: [
                            for(int i = 1; i < 13; i++)
                            DropdownMenuItem<String>(
                              value: i.toString(),
                              child: Text(i.toString(),style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                          ], 
                          onChanged:(String? newValue) {
                            setState(() {
                              std = newValue!;
                            });
                          }, 
                        ),
                      ],
                    ),
                  ),
                ) : const SizedBox(),
                SizedBox(height: screen.height*0.025),

                
                (EditAccountScreen.editUser != 'Admin') ? Container(
                  height: screen.width * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widgetColor,
                      border: Border.all(color: accentColor2, width: 2),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(children: [
                      Text("Date : \t${EditAccountScreen.joiningDate}",style: textStyle(
                                  Colors.white70, 20, FontWeight.w500, 1, 0.25),),
                      IconButton(onPressed: () => _selectDate(context),icon: const Icon(Icons.calendar_month, color: Colors.white60,size: 25))
                    ]
                    ),
                  ),
                ) : const SizedBox(),
                SizedBox(height: screen.height*0.025),
            
                SizedBox(
                  height: screen.height*0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        try {
                          setState(() {isLoading = true;});
                          final databaseRef = FirebaseDatabase.instance.ref();
                          databaseRef.child('User').child(EditAccountScreen.editUser).child(EditAccountScreen.email.replaceFirst(RegExp(r'\.[^.]*$'), '')).set(
                            (EditAccountScreen.editUser == 'Admin') ? {
                              'Name' : EditAccountScreen.name,
                              'Email' : EditAccountScreen.email,
                              'Phone Number' : EditAccountScreen.phoneNumber
                            } : 
                            (EditAccountScreen.editUser == 'Teacher') ? {
                              'Name' : name.text,
                              'Email' : EditAccountScreen.email,
                              'Joining Date' : EditAccountScreen.joiningDate,
                              'Phone Number' : EditAccountScreen.phoneNumber
                            } :
                            (EditAccountScreen.editUser == 'Student') ? {
                              'Name' : name.text,
                              'Email' : EditAccountScreen.email,
                              'Joining Date' : EditAccountScreen.joiningDate,
                              'Phone Number' : EditAccountScreen.phoneNumber,
                              'Class' : std

                            } : null
                          );
        
                          setState(() {isLoading = false;});
                            EditAccountScreen.editUser = '';
                            EditAccountScreen.name = '';
                            EditAccountScreen.phoneNumber = '';
                            EditAccountScreen.joiningDate = '';
                            EditAccountScreen.std = '';
                            
                            snackbar("Successfully Modified !", context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                        } on FirebaseAuthException catch(error) {
                          print(error);
                        }
                      }
                    },
                    child: isLoading ? const SizedBox( height: 25, width: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3,valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) :
                    buttonText('Save'),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}