import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  var title = TextEditingController();
  var desc = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: leadingBackButton(context),
        title: appBarTitleText('Add Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                
                SizedBox(height: screen.height * 0.025),
                addTextFormField('Title', title, const Icon(Icons.title, color: primaryTextColor), true),
                SizedBox(height: screen.height * 0.025),
                
                homeScreenHeading('Description:'),
                SizedBox(height: screen.height*0.005),

                addTextArea('Description', desc,
                    const Icon(Icons.email, color: Colors.white54)),
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
                          final databaseRef = FirebaseDatabase.instance.ref().child('Announcement');
                          databaseRef.child(DateFormat("dd-MM-yyyy HH'H'-mm'M'-ss'S'").format(DateTime.now())).set({
                            'Title': title.text,
                            'Description': desc.text, 
                            'Date': DateFormat("dd-MM-yyyy HH'H'-mm'M'-ss'S'").format(DateTime.now()),
                            'Author': MyApp.name
                          }).then((value) {
                            setState(() {
                              isLoading = false;
                              title = TextEditingController(text: '');
                              desc = TextEditingController(text: '');
                            });
                            title = TextEditingController(text: '');
                            desc = TextEditingController(text: '');
                            
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
                    child: isLoading ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryTextColor)
                      )
                    ) : buttonText('Save'),
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