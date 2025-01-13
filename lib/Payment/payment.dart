import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/member_list.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static String user = '';
  static String name = '';
  static String phoneNumber = '';
  static String std = '';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  String day = DateTime.now().day.toString();
  String month = 'January';
  String year = DateTime.now().year.toString();
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  List<String> days = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20','21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'];
  var amount = TextEditingController();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: paymentScreenAppBar(context,'Payment'),
      body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: key,
              child: Column(
                children: [

                  accountName(PaymentScreen.name),
                  const SizedBox(height: 25),

                  paymentTextFormField('Amount', amount, const Icon(Icons.currency_rupee_rounded,color: accentColor2,)),
                  SizedBox(height: screen.height*0.025),

                  Container(
                  height: screen.width*0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widgetColor,
                    border: Border.all(color: accentColor2,width: 2),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, left: 15),
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text((MemberList.user == 'Student') ? 'Fees Paid Date' : 'Salary Paid Date',
                            style: textStyle(Colors.white70, 20, FontWeight.w500, 1, 0.25),
                          ),
                        ),
                        SizedBox(height: screen.height*0.015),

                        Row(
                          children: [
                            DropdownButton<String>(
                              value: day,
                              items: [
                                for(int i = 1; i < 32; i++)
                                  DropdownMenuItem<String>(value: i.toString(),child: Text(i.toString(),style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                              ], 
                              onChanged:(String? newValue) {
                                setState(() {
                                  day = newValue!;
                                });
                              }, 
                            ),
                            SizedBox(width: screen.width*0.05),
                            DropdownButton<String>(
                              value: month,
                              items: [
                                for(int i = 0; i < 12; i++)
                                  DropdownMenuItem<String>(value: months[i],child:
                                   Text(months[i],style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                              ], 
                              onChanged:(String? newValue) {
                                setState(() {
                                  month = newValue!;
                                });
                              }, 
                            ),
                            SizedBox(width: screen.width*0.025),
                            DropdownButton<String>(
                              value: year,
                              items: [
                                for(int i = 2020; i <= DateTime.now().year.toInt(); i++)
                                  DropdownMenuItem<String>(value: i.toString(),child: Text(i.toString(),style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25))),
                              ], 
                              onChanged:(String? newValue) {
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
                SizedBox(height: screen.height*0.025),

              SizedBox(
                height: screen.height*0.06,
                width: double.infinity,
                    child: ElevatedButton(
                      style: buttonStyle(),
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          setState(() {isLoading = true;});
                          if(MemberList.user == 'Student') {
                            await feesPayment(context, amount, day, month, year).then((value) {});
                          }
                          else if(MemberList.user == 'Teacher') {
                            await salaryPayment(context, amount, day, month, year).then((value) {});
                          }
                          setState(() {isLoading = false;});
                        }
                      },
                      child: isLoading ? const SizedBox( height: 25, width: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3,valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) :
                    buttonText('Save'),
                  )
                )
                ],
              ),
            ),
          )
    );
  }
}