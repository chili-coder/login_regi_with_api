import 'package:flutter/material.dart';
import 'package:login_regi_with_api/screen/login.dart';
import 'package:login_regi_with_api/screen/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeshboardPage extends StatefulWidget {
  const DeshboardPage({Key? key}) : super(key: key);

  @override
  State<DeshboardPage> createState() => _DeshboardPageState();
}

class _DeshboardPageState extends State<DeshboardPage> {

  late SharedPreferences sharedPreferences;

  isLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
  }

    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),

              ],
            ),
      ) ?? false; //if showDialoug

    }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Deshboard"),
            actions: [
              InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return Container(
                        child: AlertDialog(
                          title: Text("Are you sure?"),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text("Cencle")),
                            TextButton(onPressed: () {
                              isLogout();
                            }, child: Text("Logout")),

                          ],
                        ),
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.logout),
                  )),
            ],
          ),

          body: Column(
            children: [
              Expanded(child: ProductPage()),

            ],
          ),
        ),
      );
    }
  }


