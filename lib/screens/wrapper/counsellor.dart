import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:provider/provider.dart';

class CounselorPage extends StatefulWidget {
  const CounselorPage({super.key});

  // creates background task which states which page is running
  // notice that button runs the toggleView functions from authen.dart that
  // switches between the register and sign in page.
  @override
  State<CounselorPage> createState() => _CounselorPageState();
}

class _CounselorPageState extends State<CounselorPage> {
  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);
    int selectedIndex = 0;
    var selectedCounselor = '';
    return Scaffold(
      body: Column(children: [
        Container(padding: const EdgeInsets.only(left: 25, top: 50),alignment: Alignment.topLeft,
            child: const Text("Counselors",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        Container(padding: const EdgeInsets.only(left: 28, top: 2, right: 15),alignment: Alignment.topLeft,
            child: const Text("Select who your counselor is in order to get important anouncements and updates",style: TextStyle(fontSize: 15))),
        
        const SizedBox(height: 20),
        Container(decoration: const BoxDecoration(color: Color.fromARGB(255, 246, 246, 246)),
            child: StreamBuilder(
              stream: DatabaseService(user: user).updateCounsellorSnapshot,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: heigth_sc * 0.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var counsellorPic = snapshot.data.docs[index]['profile_url'];
                          var counsellorEmail = snapshot.data.docs[index]['counsellor_email'];
                          var counsellorStd = snapshot.data.docs[index]['counsellor_std'];
                          var counsellorName = snapshot.data.docs[index]['counsellor_name'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                            child: Card( child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: selectedIndex == index
                                          ? Colors.black
                                          : Colors.white,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                leading: CircleAvatar( radius: 45, backgroundImage: NetworkImage(counsellorPic)),
                                title: Text(counsellorName),
                                subtitle: Text('$counsellorStd\nEmail: $counsellorEmail'),
                                isThreeLine: true,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    DatabaseService(user: user).addCounsellor(counsellorName);
                                    DatabaseService(user: user).updateCounsellorMemberList(counsellorName);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                  );
                }
                return const LinearProgressIndicator();
              },
            ))
      ]),
    );
  }
}