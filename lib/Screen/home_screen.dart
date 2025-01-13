import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    getUserInformation().then((value) {setState(() {});});
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    var screen = MediaQuery.sizeOf(context);

    return Scaffold(

      backgroundColor: Colors.black,
      appBar: homeScreenAppBar(context),
      body: Padding(

        padding: EdgeInsets.only(
          top: screen.height*0.025,
          left: screen.width*0.05,
          right: screen.width*0.05,
        ),

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              
              (MyApp.user == 'Admin') ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  monthlyCollectionBox(screen,'Fees',context),
                  SizedBox(width: screen.width*0.05),
                  monthlyCollectionBox(screen,'Salary',context),
                ],
              ) : 
              const SizedBox(),
              
              (MyApp.user == 'Admin') ? 
              SizedBox(height: screen.height*0.02) : 
              const SizedBox(),

              homeScreenHeading('Members'),
              SizedBox(height: screen.height*0.005),

              memberListContainer(screen, 'Admin Information',context),
              SizedBox(height: screen.height*0.02),
              memberListContainer(screen, 'Teacher Information',context),
              SizedBox(height: screen.height*0.02),
              memberListContainer(screen, 'Student Information',context),

              SizedBox(height: screen.height*0.02),
          
              (MyApp.user == 'Admin') ? 
              homeScreenHeading('Add Members') : 
              const SizedBox(),
              
              (MyApp.user == 'Admin') ? 
              SizedBox(height: screen.height*0.005) : 
              const SizedBox(),

              (MyApp.user == 'Admin') ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addTeacherStudentContainer(context,screen,'Student'),
                  SizedBox(width: screen.width*0.05),
                  addTeacherStudentContainer(context,screen,'Teacher'),
                ],
              ) : 
              const SizedBox(),
              
              (MyApp.user != 'Admin') ? 
              SizedBox(height: screen.height*0.02) : 
              const SizedBox(),

              (MyApp.user == 'Teacher') ? 
              homeScreenHeading('Your Salary') : 
              const SizedBox(),

               (MyApp.user == 'Teacher') ? 
               paymentHistoryContainer(screen, 'Salary Payment History', context) : 
              const SizedBox(),

              (MyApp.user == 'Student') ? 
              homeScreenHeading('Your Fees') : 
              const SizedBox(),

               (MyApp.user == 'Student') ? 
               paymentHistoryContainer(screen, 'Fees Payment History', context) : 
              const SizedBox(),

              (MyApp.user == 'Admin') ? 
              SizedBox(height: screen.height*0.02) : 
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}