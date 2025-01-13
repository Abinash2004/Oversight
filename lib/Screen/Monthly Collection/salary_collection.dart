import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';

class SalaryCollection extends StatefulWidget {
  const SalaryCollection({super.key});

  @override
  State<SalaryCollection> createState() => _SalaryCollectionState();
}

class _SalaryCollectionState extends State<SalaryCollection> {
  int collection = 0;
  bool isExist = false;
  String user = 'Both Admin';
  String month = 'January';
  String year = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final databaseRef = FirebaseDatabase.instance.ref('Payment').child('Salary');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: accentColor1,
        title: appBarTitleText('Monthly Salary'),
        leading: leadingBackButton(context)
      ),
      body: 
      Column(
        children: [
          SizedBox(height: screen.height*0.015),
          Container(
            height: screen.width*0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widgetColor,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10, left: 15),
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Date : ',
                        style: textStyle(Colors.white70, 20, FontWeight.w500, 1, 0.25),
                      ),
                    ),
                    SizedBox(width: screen.width*0.1),
                    DropdownButton<String>(
                      value: month,
                      items: [
                        for(int i = 0; i < 12; i++)
                        DropdownMenuItem<String>(value: months[i],child:Text(months[i],style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                      ], 
                      onChanged:(String? newValue) {
                        setState(() {month = newValue!;collection = 0;});
                      }, 
                    ),
                    SizedBox(width: screen.width*0.1),
                    
                    DropdownButton<String>(
                      value: year,
                      items: [
                        for(int i = 2021; i <= DateTime.now().year.toInt(); i++)
                        DropdownMenuItem<String>(value: i.toString(),child: Text(i.toString(),style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                              ], 
                        onChanged:(String? newValue) {
                          setState(() {year = newValue!;collection = 0;});
                        }, 
                      ),
                    ],
                  ),
                  SizedBox(height: screen.height*0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: buttonStyle(),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: widgetColor,
                              builder: (BuildContext context) {
                                return Container(
                                  height: screen.height*0.15,
                                  decoration: BoxDecoration(
                                    color: widgetColor,
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.currency_rupee_rounded, color: accentColor2,size: 40),
                                      Text(collection.toString(), style: textStyle(Colors.white70, 40, FontWeight.w500, 1, 0.25))
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: buttonText('Collection')
                      ),
                      SizedBox(width: screen.width*0.05),
                    ],
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream:databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.data!.snapshot.children.isEmpty) {
                  return const Center(child: Text('No Fees Recieved',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
                }
                else {  
                  Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context,index) {
                      if(list[index]['Date'].contains(month) && list[index]['Date'].contains(year) && (user != 'Both Admin' ? list[index]['By'] == user : true)){
                        collection = collection + int.parse(list[index]['Amount']);
                        isExist = true;
                      } else {
                        isExist = false;
                      }
                      return isExist ? Card(
                        color: widgetColor,
                        child: ListTile(
                          title: memberListTitle('${list[index]['Name']} - ₹${list[index]['Amount']}'),
                          subtitle: memberListSubTitle('${list[index]['Date']} - By ${list[index]['By']}'),
                        )
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
