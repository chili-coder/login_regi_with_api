import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_regi_with_api/screen/deshboard.dart';
import 'package:login_regi_with_api/screen/regi.dart';
import 'package:login_regi_with_api/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String ? token;
  String uri_signin="https://apihomechef.antopolis.xyz/api/admin/sign-in";
 late  SharedPreferences sharedPreferences;

 isLogin() async{
   sharedPreferences = await SharedPreferences.getInstance();
   if(sharedPreferences.getString("token")!=null){
     Navigator.of(context)
         .pushReplacement(MaterialPageRoute(builder: (context)=>DeshboardPage()));

   }else{
     print("token is null");
   }
 }

  getLogin() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, dynamic>();
    map["email"] = emailController.text.toString();
    map["password"] = passwordController.text.toString();

    var responce = await http.post(
      Uri.parse(uri_signin),
      body: map,

    );

    var data = jsonDecode(responce.body);
    if (responce.statusCode == 200) {
      showInToast("Login Successful");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context)=>DeshboardPage()));
      setState(() {
        sharedPreferences.setString("token", data["access_token"]);

      });
      token=sharedPreferences.getString("token");

    } else {
      showInToast("${data["errors"]["email"]}");
    }

    setState(() {
      isLoading = false;
    });
  }

@override
  void initState() {
    // TODO: implement initState
  isLogin();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,

      ),

      body: Container(
        child: Form(

          child: Padding(
            padding: const EdgeInsets.only(left: 40,right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextFormField(
                  autofocus: false,
               //   validator: validateEmail,
                  controller: emailController,
                  decoration: buildInputDecoration("Email", Icons.email),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  //   validator: validateEmail,
                  controller: passwordController,
                  decoration: buildInputDecoration("Password", Icons.lock),
                ),
                SizedBox(height: 25,),
                OutlinedButton(
                  onPressed: () {
                    getLogin();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Login'),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("I have no an account please"),
                InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegiPage()),
                      );
                    },
                    child: Text("Create an account",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
