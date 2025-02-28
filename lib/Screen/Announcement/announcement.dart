import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Screen/Announcement/create_announcement.dart';
import 'package:finance_tracker/Screen/Announcement/view_announcement.dart';
import 'package:finance_tracker/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {

  final databaseRef = FirebaseDatabase.instance.ref('Announcement');

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);
    return Scaffold(
      
      backgroundColor: bgColor,
      
      appBar: AppBar(
        leading: leadingBackButton(context),
        backgroundColor: bgColor,
        title: appBarTitleText('Announcements'),
      ),
      
      floatingActionButton: (MyApp.user != 'Student') ? FloatingActionButton(
        backgroundColor: accentColor1, // Change color if needed
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const CreateAnnouncement()));
        },
        child: const Icon(Icons.add, color: primaryTextColor), // Icon inside FAB
      ) : null,
      
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
                  return Center(
                    child: Text('No Data Available',
                      style: textStyle(primaryTextColor, 20, FontWeight.w500, 1, 0.25),
                    ),
                  );
                } else {
                  // Process the data
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = map.values.toList();

                  // Correct DateTime format parser
                  DateFormat format = DateFormat("dd-MM-yyyy HH'H'-mm'M'-ss'S'");

                  // Sort in DESCENDING order based on 'Date' field (latest first)
                  list.sort((a, b) {
                    DateTime dateA = format.parse(a['Date']);
                    DateTime dateB = format.parse(b['Date']);
                    return dateB.compareTo(dateA); // Descending order
                  });

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: widgetColor,
                        child: ListTile(
                          title: memberListTitle(list[index]['Title']),
                          subtitle: memberListSubTitle(list[index]['Date']),
                          onTap: () {
                            ViewAnnouncement.title = list[index]['Title'];
                            ViewAnnouncement.desc = list[index]['Description'];
                            ViewAnnouncement.date = list[index]['Date'];
                            ViewAnnouncement.author = list[index]['Author'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewAnnouncement()));
                          },
                          onLongPress: (MyApp.user != "Student") ? () {
                            deletAccount(context, screen, databaseRef, "this announcement", list[index]['Date']);  
                          } : null
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
