// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vonette_mobile/models/user.dart';

// check the auth.dart when the person first registers, then the DataService is
// called to create a database for the user with the user.uid
class DatabaseService {
  final UserInApp? user;
  DatabaseService({this.user});

  final CollectionReference<Map<String, dynamic>> _userInfo =
    FirebaseFirestore.instance.collection('UserInformation');

  final CollectionReference<Map<String, dynamic>> _userClubInfo = 
    FirebaseFirestore.instance.collection('UserClubInformation');

  final CollectionReference<Map<String, dynamic>> _userCounsInfo = 
    FirebaseFirestore.instance.collection('UserCounsellorInfo');


  Future firstTimeCreateDM(String? profile_url) async {
    String username = '';
    List<String> stringList = [];

    if (user?.username != null) {
      username = user?.username as String;
      for (int i = 0; i < username.length; i++) {
        stringList.add(username.substring(0,i+1));
      }
    } else {
      stringList = ['Search Feature Not Available'];
    }
    
    return await _userInfo.doc(user?.uid).set({
      'username': user?.username,
      'email': user?.email,
      'uid': user?.uid,
      'profile_url': profile_url,
      'counsellor': 'Counsellor: None',
      'successful': false,
      'searchKey': stringList
    });
  }

  Future addMessagesToDM(String msg, String? currentID, String? friendID) async {
    var now = DateTime.now();
    await _userInfo.doc(currentID).collection('Messages').doc(friendID)
        .collection("Chats").add({
      "senderID": currentID,"receiverID": friendID,
      "message": msg,"type": "text","date": now
    }).then((value) {
        _userInfo.doc(currentID).collection("Messages").doc(friendID).set({
          "lastMsg": msg, "lastTime":
              "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\n${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"
        }); });

    await _userInfo.doc(friendID).collection('Messages').doc(currentID)
      .collection("Chats").add({
      "senderID": currentID, "receiverId": friendID, 
      "message": msg, "type": "text",  "date": now
    }).then( (value) {
        _userInfo.doc(friendID).collection("Messages").doc(currentID).set({
          "lastMsg": msg, "lastTime":
              "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\n${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"
        });});
  }
  Stream<QuerySnapshot> get updateUserStream {
    return _userInfo.snapshots();}

  Stream<QuerySnapshot> get updateMessagesStream {
    return _userInfo.doc(user?.uid).collection('Messages').snapshots();}

  Future getSpecifiedDatabase(String FriendID) {
    return _userInfo.doc(FriendID).get();}

  CollectionReference<Map<String, dynamic>> get getEntireMsgDB{
    return _userInfo;}

  Stream<DocumentSnapshot> get getCurrentUserDM {
    return _userInfo.doc(user?.uid).snapshots();}

  Stream<QuerySnapshot> updateChatsStream(String friendID) {
    return _userInfo.doc(user?.uid).collection('Messages').doc(friendID)
      .collection('Chats').orderBy('date', descending: true).snapshots(); } 

  Future addCounsellor(String counsellorName) async {
    return await _userInfo.doc(user?.uid).update({
      "counsellor": counsellorName
    });
  }

  Future updateSuccess() async {
    return await _userInfo.doc(user?.uid).update({
      "successful": true
    });
  }

  Future addProfileImageUrl(String url) async {
    return await _userInfo.doc(user?.uid).update({
      "profile_url": url
    });
  }

  Future? searchUserByName(String searchField) {
    return _userInfo.where('searchKey', arrayContains: searchField).get()
    .then((querysnapshot) {
      if (querysnapshot.size == 0)
      { return null; } else {
        var docs = querysnapshot.docs.map((e) => e.data());
        return docs.toList();
      }
    });
  }

  Future get getUsernameList {
    return _userInfo.get().then((querysnapshot) {
      if (querysnapshot.size == 0) {
        return null; } else {
          var docs = querysnapshot.docs.map((e) => e.data()['username']);
          return docs.toList();
        }
    });
  }

  Future get getUIDList {
    return _userInfo.get().then((value) {
      if (value.size == 0) {
        return null; } else {
          var docs = value.docs.map((e) => e.data()['uid']);
          return docs.toList();
        }
    });
  }


  





  Future createCalendarEvents(int? day, int? year, int? month, String? title, 
    String? startTime, String? endTime, String? club, String? desc) async {
    return await _userInfo.doc(user?.uid)
      .collection('Calendar').add({
        'chosen_start_time': startTime,
        'chosen_end_time': endTime,
        'chosen_title': title,
        'chosen_club': club,
        'date_day': day,
        'date_year': year,
        'date_month': month,
        'description': desc,
        'event_uid': null
      }).then((value) {
        _userInfo.doc(user?.uid).collection('Calendar')
          .doc((value.id)).update({
            'event_uid': value.id
          });
      }); 
  }

  Stream<QuerySnapshot> get getCalendarStream {
    return _userInfo.doc(user?.uid).collection('Calendar').snapshots();
  }
  
  Future deleteCalendarEvents(String uid) {
    return _userInfo.doc(user?.uid).collection('Calendar').doc(uid).delete();
  }
    
  









  Future addClubInformation(String clubName, String clubDesc, String advAddr, bool private, String password) async {
    List<String> stringList = [];
    for (int i = 0; i < clubName.length; i++) {
      stringList.add(clubName.substring(0,i+1));
    }

    return await _userClubInfo.doc(clubName).set({
      'club_name': clubName,
      'club_desc': clubDesc,
      'advisor_email': advAddr,
      'club_members': [],
      'admin_members': [],
      'profile_url': 'https://tinyurl.com/2p8cdr9d',
      'searchKey': stringList,
      'private': private,
      'private_password': password
    });}

  CollectionReference<Map<String, dynamic>> get getClubsStream {
    return _userClubInfo; }

  Stream<QuerySnapshot> get updateClubSnapshot {
    return _userClubInfo.snapshots();}

  Future specifiedClubSnapshot(String? clubName) {
    return _userClubInfo.doc(clubName).get(const GetOptions(source: Source.cache));}

  Future addGroupMsgToDB(
      String msg, String? clubName) async {
    var now = DateTime.now();
    await _userClubInfo.doc(clubName).collection('Chats').add({
        "userID": user?.uid,
        "message": msg,"type": "text","date": now
    }).then((value) => null);
  }

  Stream<QuerySnapshot> updateClubChatsStream(String clubName) {
    return _userClubInfo.doc(clubName).collection('Chats')
      .orderBy('date', descending: true).snapshots(); } 

  Future<void> updateClubMemberList(String clubName) async {
    return _userClubInfo.doc(clubName)
      .update({ 'club_members': FieldValue.arrayUnion([user?.uid])});}

  Future<void> updateClubAdminList(String clubName) async {
    return _userClubInfo.doc(clubName)
      .update({ 'admin_members': FieldValue.arrayUnion([user?.uid])});}

  Future<void> updateClubAdminList2(String? clubName, String uid) async {
    return _userClubInfo.doc(clubName)
      .update({ 'admin_members': FieldValue.arrayUnion([uid])});}

  Future<void> removeClubMemberList(String? clubName) async {
    return _userClubInfo.doc(clubName)
      .update({ 'club_members': FieldValue.arrayRemove([user?.uid])});}

  Future<void> removeClubMemberList2(String? clubName, String uid) async {
    return _userClubInfo.doc(clubName)
      .update({ 'club_members': FieldValue.arrayRemove([uid])});}

  Future addClubProfileImageUrl(String? url, String clubName) async {
    return await _userClubInfo.doc(clubName).update({
      "profile_url": url
    });}
  
  Future updatePrivateOption(bool private, String clubName) async {
    return await _userClubInfo.doc(clubName).update({
      "private": private
    });}

  Future updatePasswordForPrivate(String password, String clubName) async {
    return await _userClubInfo.doc(clubName).update({
      "private_password": password
    });}

  Future updateClubDesc(String desc, String clubName) async {
    return await _userClubInfo.doc(clubName).update({
      "club_desc": desc
    });}

  Future? searchClubByName(String searchField) {
    return _userClubInfo.where('searchKey', arrayContains: searchField).get()
    .then((querysnapshot) {
      if (querysnapshot.size == 0)
      { return null; } else {
        var docs = querysnapshot.docs.map((e) => e.data());
        return docs.toList();
      }
    });
  }

  Future get getClubNameList {
    return _userClubInfo.get().then((querysnapshot) {
      if (querysnapshot.size == 0) {
        return null; } else {
          var docs = querysnapshot.docs.map((e) => e.data()['club_name']);
          return docs.toList();
        }
    });
  }

  Future get getClubListData {
    return _userClubInfo.get().then((querysnapshot) {
      if (querysnapshot.size == 0) {
        return null; } else {
          var docs = querysnapshot.docs.map((e) => e.data());
          return docs.toList();
        }
    });
  }

  Future getClubPassword(String clubName) {
    return _userClubInfo.doc(clubName).get().then((querysnapshot) {
      if(querysnapshot.exists) {
        return querysnapshot.data()!['private_password'];
      } else { return null; }
    });
  }

  Future checkClubPrivate(String clubName) {
    return _userClubInfo.doc(clubName).get().then((docsnapshot) {
      if (docsnapshot.exists) {
        return docsnapshot.data()!['private'];
      } else { return null; }
    });
  }













  Future addCounsellorInfo(String counName, String counStds, String counEmail) async {
    return await _userCounsInfo.doc(counName).set({
      'counsellor_name': counName,
      'counsellor_std': counStds,
      'counsellor_email': counEmail,
      'club_members': [],
      'admin_members': [],
      'profile_url': 'https://tinyurl.com/2p8cdr9d',
    });}  

  Stream<QuerySnapshot> get updateCounsellorSnapshot {
    return _userCounsInfo.snapshots();}

  Stream<QuerySnapshot> updateCounsellorChatsStream(String clubName) {
    return _userCounsInfo.doc(clubName).collection('Chats')
      .orderBy('date', descending: true).snapshots(); } 
  
  Future<void> updateCounsellorMemberList(String counsellorName) async {
    return _userCounsInfo.doc(counsellorName)
      .update({ 'club_members': FieldValue.arrayUnion([user?.uid])}); }

  Future<void> updateCounsellorAdminList(String counsellorName) async {
    return _userCounsInfo.doc(counsellorName)
      .update({ 'admin_members': FieldValue.arrayUnion([user?.uid])}); }

  Future addCounsellorProfileImageUrl(String url, String counsellorName) async {
    return await _userCounsInfo.doc(counsellorName).update({
      "profile_url": url
    });}

  Future specifiedCounsellorSnapshot(String? counsellorName) {
    return _userCounsInfo.doc(counsellorName).get(const GetOptions(source: Source.cache));}
}
