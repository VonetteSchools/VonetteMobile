// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/wrapper/pwdVerfication2.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/shared/loading.dart';

class ClubsClasses extends StatefulWidget {
  const ClubsClasses({super.key});

  @override
  State<ClubsClasses> createState() => _ClubsClassesState();
}

class _ClubsClassesState extends State<ClubsClasses> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInApp?>(context);
    double height_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;

    return Scaffold(
      /* appBar: PreferredSize(
          preferredSize: Size.fromHeight(heigth_sc * 0.10),
          child: AppBar(
              centerTitle: true,
              title: const Text("Clubs and Classes"),
              flexibleSpace: Container(decoration: purpleGradient))), */
      body: Column(children: [
        Container(
            padding: const EdgeInsets.only(left: 25, top: 50),
            alignment: Alignment.topLeft,
            child: const Text("Choose Clubs",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        Container(
            padding: const EdgeInsets.only(left: 28, top: 2, right: 15),
            alignment: Alignment.topLeft,
            child: const Text(
                "Browse and select clubs that you are interested in being apart of!",
                style: TextStyle(fontSize: 15))),
        StreamBuilder(
          stream: DatabaseService(user: user).updateClubSnapshot,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Container(
                        height: height_sc * 0.8,
                        child: Scrollbar(
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  var clubName =
                                      snapshot.data.docs[index]['club_name'];
                                  var clubDesc =
                                      snapshot.data.docs[index]['club_desc'];
                                  var advEmail = snapshot.data.docs[index]
                                      ['advisor_email'];
                                  var profileUrl =
                                      snapshot.data.docs[index]["profile_url"];

                                  return buildInfoCard(profileUrl, clubName, clubDesc,
                                      advEmail, user, context);
                                }))))
              ]);
            }
            return const Loading();
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            DatabaseService(user: user).updateSuccess();
          },
          child: const Icon(Icons.arrow_forward_outlined)),
    );
  }
}

Widget buildInfoCard(String profileUrl, String title, String description, String advisors,
    UserInApp? user, BuildContext context) {
  double width_sc = MediaQuery.of(context).size.width;
  return Card(
    elevation: 10,
    shape: const RoundedRectangleBorder(
        /* side: BorderSide(color: Colors.black45), */
        borderRadius: BorderRadius.all(Radius.circular(6))),
    child: InkWell(
        splashColor: Colors.black.withAlpha(30),
        onTap: () {
          debugPrint('$title card tapped');
        },
        child: Row(children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(profileUrl)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: width_sc * 0.685,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      constraints: BoxConstraints(minWidth: 00, maxWidth: 100),
                      child: Text(title,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 15))),
                  const SizedBox(),
                  Container(
                      constraints: BoxConstraints(minWidth: 00, maxWidth: 100),
                      child: Text('$description.',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12))),
                  /* const SizedBox(
                    height: 10,
                  ), */
                  Container(
                      width: 81,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (await DatabaseService(user: user)
                                .checkClubPrivate(title)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          PwdVerification(clubName: title))));
                            } else {
                              DatabaseService(user: user)
                                  .updateClubMemberList(title);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 144, 98, 224),
                              textStyle: const TextStyle(fontSize: 12)),
                          child: const Text("Add Club")))
                ],
              ),
            ),
          ),
        ])),
  );
}
