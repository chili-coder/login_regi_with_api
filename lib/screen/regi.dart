
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_regi_with_api/http/custome_http_request.dart';
import 'package:login_regi_with_api/screen/login.dart';
import 'package:login_regi_with_api/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegiPage extends StatefulWidget {
  const RegiPage({Key? key}) : super(key: key);

  @override
  State<RegiPage> createState() => _RegiPageState();
}

class _RegiPageState extends State<RegiPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String uri = "https://apihomechef.antopolis.xyz/api/admin";
  getRegister() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, dynamic>();
    map["name"] = nameController.text.toString();
    map["email"] = emailController.text.toString();
    map["password"] = passwordController.text.toString();
    map["password_confirmation"] = confirmPasswordController.text.toString();
    var responce = await http.post(
      Uri.parse("$uri/create/new/admin"),
      body: map,
      headers: CustomHttpRequest.defaultHeader,
    );
    print("${responce.body}");
    var data = jsonDecode(responce.body);
    if (responce.statusCode == 201) {
      showInToast("Registation Successful");
    } else {
      showInToast("${data["errors"]["email"]}");
    }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an account"),
        centerTitle: true,

      ),

      body: ModalProgressHUD(
        inAsyncCall: isLoading == true,
        opacity: 0.0,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          child: Form(

            child: Padding(
              padding: const EdgeInsets.only(left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextFormField(
                    autofocus: false,
                    //   validator: validateEmail,
                    controller: nameController,
                    decoration: buildInputDecoration("Name", Icons.person),
                  ),
                  SizedBox(height: 10,),
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
                  SizedBox(height: 10,),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    //   validator: validateEmail,
                    controller: confirmPasswordController,
                    decoration: buildInputDecoration("Password Confirmation", Icons.lock),
                  ),
                  SizedBox(height: 25,),
                  OutlinedButton(
                    onPressed: () {
                      getRegister();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Register'),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("I have an account"),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text("Login",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
