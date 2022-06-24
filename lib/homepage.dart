import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/usermodels.dart';
import 'loginpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value){
        this.loggedInUser= UserModel.fromMap(value.data());
        setState((){});
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",height: 200,width:200 ,),
            Text("Welcome Back", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 5,),
            Text("${loggedInUser.firstname} ${loggedInUser.lastname}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),),
            SizedBox(height: 5,),
            Text("${loggedInUser.email}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ActionChip(label: Text("Logout",style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold)), padding: EdgeInsets.all(15), backgroundColor: Colors.blue, elevation: 5,onPressed: (){logout(context);},),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Loginpage()),);
  }
}