import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Screen/Account/account_screen.dart';
import 'package:finance_tracker/main.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key});
  static String user = '';

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  final databaseRef = FirebaseDatabase.instance.ref('User').child(MemberList.user);
  String std = '1';
  bool isClass = true;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);

    return Scaffold(
      
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        backgroundColor: accentColor1,
        title: appBarTitleText('${MemberList.user} List'),
        actions: (MemberList.user == 'Student') ? [ DropdownButton<String>(
          value: std,
          items: [
            for (int i = 1; i <= 12; i++)
            DropdownMenuItem<String>(
              value: i.toString(),
              child: Text('Class $i',style: textStyle(Colors.white, 20, FontWeight.w500, 1, 0.25))),
          ],
          onChanged: (String? newValue) {
            setState(() {std = newValue!;});
          },
        )] : null,
      ),
      
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                );
              } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                // No data available case
                  return Center(
                    child: Text('No Data Available',style:textStyle(Colors.white70, 20, FontWeight.w500, 1, 0.25),
                    ),
                  );
              } else {
                // Process the data
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = map.values.toList();
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    if (MemberList.user == 'Student') {
                      if (list[index]['Class'] != std) {
                        isClass = false;
                      } else {
                        isClass = true;
                      }
                    }
                    return isClass ? Card(
                      color: widgetColor,
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: accentColor2,
                          size: 35,
                        ),
                        title: memberListTitle(list[index]['Name']),
                        subtitle: memberListSubTitle('+91 ${list[index]['Phone Number']}'),
                        
                        onTap: () async {
                          AccountScreen.user = MemberList.user;
                          AccountScreen.name = list[index]['Name'];
                          AccountScreen.email = list[index]['Email'];
                          AccountScreen.phoneNumber = list[index]['Phone Number'];
                          (MemberList.user != 'Admin') ? AccountScreen.joiningDate = list[index]['Joining Date'] : null;
                          (MemberList.user == 'Student') ? AccountScreen.std = list[index]['Class'] : null;
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AccountScreen()));
                        },
                        
                        onLongPress: (MyApp.user == 'Admin' && MemberList.user != "Admin") ? () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: widgetColor,
                            builder: (BuildContext context) {
                              return Container(
                                width: double.infinity,
                                height: screen.height * 0.15,
                                decoration: const BoxDecoration(
                                  color: widgetColor,
                                  borderRadius:
                                  BorderRadius.only(
                                    topLeft:
                                    Radius.circular(30),
                                    topRight:
                                    Radius.circular(30),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        
                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? Column(
                                          children: [
                                            memberListIconButton(context,screen,const Icon(Icons.delete_rounded,size: 40,color:accentColor1),databaseRef,list[index]['Name'],list[index]['Phone Number'],list[index]['Email'],'','','Delete'),
                                            memberListText('Delete\nAccount'),
                                          ],
                                        ) : const SizedBox(),
                                        
                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? SizedBox(width: screen.width * 0.1) : const Text(''),
                                        
                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? Column(
                                          children: [
                                            memberListIconButton(context,screen,const Icon(Icons.history,size: 40,color:accentColor1),databaseRef,list[index]['Name'],list[index]['Phone Number'],list[index]['Email'],(MemberList.user !='Admin')? list[index]['Joining Date']: '','','Payment History'),memberListText('Payment\nHistory'),
                                          ],
                                        ) : const Text(''),

                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? SizedBox(width:screen.width *0.1): const Text(''),

                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? Column(
                                          children: [
                                            memberListIconButton(context,screen,const Icon(Icons.currency_rupee_rounded,size: 40,color:accentColor1),databaseRef,list[index]['Name'],list[index]['Phone Number'],list[index]['Email'],'',(MemberList.user =='Student')? list[index]['Class']: '','Payment'),memberListText('Payment')
                                          ]
                                        ) : const SizedBox(),
                                        
                                        (MyApp.user == 'Admin' && MemberList.user != 'Admin') ? SizedBox( width: screen.width * 0.1): const Text(''),
                                        
                                        Column(
                                          children: [
                                            memberListIconButton(context,screen,const Icon(Icons.edit_document,size: 40,color:accentColor1),databaseRef,list[index]['Name'],list[index]['Phone Number'],list[index]['Email'],(MemberList.user !='Admin')? list[index]['Joining Date']: '',(MemberList.user =='Student')? list[index]['Class']: '','Edit Account'),memberListText('Edit\nAccount'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            }
                          );
                        }: null,
                      ),
                    ): const SizedBox(width: 0, height: 0);
                  },
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
