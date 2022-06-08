import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_regi_with_api/http/custome_http_request.dart';
import 'package:login_regi_with_api/model/ordermodel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  List<OrderModel>list=[];
  late OrderModel orderModel;
  String order_api="https://apihomechef.antopolis.xyz/api/admin/all/orders";
  bool isLoading = false;
  fetchData() async{
    var responce= await http.get(Uri.parse(order_api),
    headers: await CustomHttpRequest().getHeaderWithToken()
    );

    if(responce.statusCode==200){
      var data=jsonDecode(responce.body);
      for(var i in data){
        orderModel=OrderModel.fromJson(i);
        setState(() {
          list.add(orderModel);
        });

      }
    }


  }

  @override
  void initState(){
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount:list.length ,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 5,child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(

                              children: [
                                Text("#"),
                                Text("${list[index].id}"),

                              ],),
                            Row(children: [
                              Text("Product: "),
                              Text("${list[index].orderStatus!.orderStatusCategory!.name}"),

                            ],),
                            Row(children: [
                              Text("\$ "),
                              Text("${list[index].price}"),

                            ],),


                          ],
                        )),
                        Expanded(flex: 3,child: Column(

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Payment Status: "),
                                Text("${list[index].payment!.paymentStatus}"),

                              ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("User: "),
                                Text("Admin"),

                              ],),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),

              ],

            );
          }),
    );
  }
}
