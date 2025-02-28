import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/main.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});
  static String name = '';
  static String user = '';
  static String phoneNumber = '';
  static String joiningDate = '';

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  bool isExist = false;
  final amount = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Payment').child((PaymentHistory.user == 'Student') ? 'Fees' : 'Salary');
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: leadingBackButton(context),
        title: appBarTitleText('Payment History'),
      ),
      body: Column(
        children: [
          (MyApp.user == 'Admin' && PaymentHistory.user == 'Student') ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: screen.height*0.14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    
                    accountDetails('Name:\t\t\t\t\t${PaymentHistory.name}'),  
                    SizedBox(height: screen.height*0.025),
                    accountDetails('Joining Date:\t\t\t\t\t${PaymentHistory.joiningDate}')  
                  ],
                ),
              ),
            ),
          ) : const SizedBox(),
          SizedBox(height: screen.height*0.01),
          
          (MyApp.user == 'Admin' && PaymentHistory.user == 'Teacher') ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: screen.height*0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        accountDetails('Joining Date:\t\t\t\t\t${PaymentHistory.joiningDate}')  
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ) : const SizedBox(),
          SizedBox(height: screen.height*0.01),
          
          Expanded(
            child: StreamBuilder(
              stream:databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: primaryTextColor));
                }
                else if (snapshot.data!.snapshot.children.isEmpty) {
                  return const Center(child: Text('No Payment Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
                }
                else {
                    Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    
                    return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context,index) {
                        if(list[index]['Phone Number'] == PaymentHistory.phoneNumber) {
                          isExist = true;
                        }
                        else {
                          isExist = false;
                        }
                        return isExist ? Card(
                        color: widgetColor,  
                      child: ListTile(
                        leading: const Icon(Icons.person,color: accentColor2,size: 35),
                        title: memberListTitle('₹ ${list[index]['Amount']} - By ${list[index]['By']}'),
                        subtitle: memberListSubTitle(list[index]['Date']),
                      ),
                    ) : const SizedBox();
                    }
                  );
                }
              }
            )
          )
        ],
      ),
    );
  }
}