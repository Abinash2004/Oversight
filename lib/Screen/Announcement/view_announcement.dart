import 'package:finance_tracker/Elements/widgets.dart';
import 'package:flutter/material.dart';

class ViewAnnouncement extends StatefulWidget {
  const ViewAnnouncement({super.key});
  static String title = "";
  static String desc = "";
  static String date = "";
  static String author = "";

  @override
  State<ViewAnnouncement> createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: leadingBackButton(context),
        // title: appBarTitleText('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50,left: 25,right: 25),
        child: Column(
          children: [

            SizedBox(height: 1, width: double.infinity, child: Container(color: primaryTextColor,),),
            SizedBox(height: screen.height*0.05),
      
            announcementTitle(ViewAnnouncement.title),
            SizedBox(height: screen.height*0.05),

            announcementDesc(ViewAnnouncement.desc),
            SizedBox(height: screen.height*0.05),

            announcementDesc(ViewAnnouncement.date),
            SizedBox(height: screen.height*0.005),
            
            announcementDesc(ViewAnnouncement.author),
            SizedBox(height: screen.height*0.05),

            SizedBox(height: 1, width: double.infinity, child: Container(color: primaryTextColor,),),
          ],
        ),
      ),
    );
  }
}