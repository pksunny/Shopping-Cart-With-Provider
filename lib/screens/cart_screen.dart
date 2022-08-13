// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_with_provider_app/helper/db_helper.dart';
import 'package:shopping_cart_with_provider_app/models/cart_model.dart';
import 'package:shopping_cart_with_provider_app/provider/cart_provider.dart';
import 'package:shopping_cart_with_provider_app/screens/reuseable_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        centerTitle: true,

        // ignore: prefer_const_literals_to_create_immutables
        actions: [

          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return  Text(value.getCounter().toString(), style: TextStyle(color: Colors.white),);
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),

          SizedBox(width: 20,),
        ],
      ),
      
      body: Column(
        children: [

          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {

              if(snapshot.hasData){

                if(snapshot.data!.isEmpty){

                  return Center(
                    child: Text('Cart is Empty!'),
                  );
                } else {

                  return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(
                                          snapshot.data![index].image.toString()),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data![index].productName.toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      int quantity = snapshot.data![index].quantity;
                                                      int initialPrice = snapshot.data![index].initialPrice;
                                                      quantity--;

                                                      int? newPrice = initialPrice * quantity;

                                                      if(quantity >= 1) {
                                                        dbHelper.updateQunatity(
                                                        Cart(
                                                          id: snapshot.data![index].id, 
                                                          productId: snapshot.data![index].id.toString(), 
                                                          productName: snapshot.data![index].productName, 
                                                          initialPrice: snapshot.data![index].initialPrice, 
                                                          productPrice: newPrice, 
                                                          quantity: quantity, 
                                                          unitTag: snapshot.data![index].unitTag.toString(), 
                                                          image: snapshot.data![index].image.toString()
                                                          )
                                                        ).then((value){

                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                          
                                                          
                                                        }).onError((error, stackTrace){
                                                          print(error.toString());
                                                        });
                                                      } else {
                                                        var snackBar = SnackBar(content: Text('Quantity cannot be less than 1'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }

                                                      
                                                    },
                                                    child: Icon(Icons.remove)
                                                  ),
                                                  ElevatedButton(
                                                    child: Text(snapshot.data![index].quantity.toString(),),
                                                    onPressed: () {},
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      int quantity = snapshot.data![index].quantity;
                                                      int initialPrice = snapshot.data![index].initialPrice;
                                                      quantity++;

                                                      int? newPrice = initialPrice * quantity;

                                                      dbHelper.updateQunatity(
                                                        Cart(
                                                          id: snapshot.data![index].id, 
                                                          productId: snapshot.data![index].id.toString(), 
                                                          productName: snapshot.data![index].productName, 
                                                          initialPrice: snapshot.data![index].initialPrice, 
                                                          productPrice: newPrice, 
                                                          quantity: quantity, 
                                                          unitTag: snapshot.data![index].unitTag.toString(), 
                                                          image: snapshot.data![index].image.toString()
                                                        )
                                                      ).then((value){

                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));

                                                        
                                                      }).onError((error, stackTrace){
                                                        print(error.toString());
                                                      });
                                                    },
                                                    child: Icon(Icons.add)
                                                  ),
                                                ],
                                              )
                                            ]
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            snapshot.data![index].unitTag.toString() +
                                                " " +
                                                r"$" +
                                                snapshot.data![index].productPrice.toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              child: Text('Delete from cart'),
                                              onPressed: () {

                                                dbHelper.delete(snapshot.data![index].id);

                                                cart.removeCounter();

                                                cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );  
              }
            }
          ),

          // DISPLAY TOTAL PRICE
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toString() == '0.00' ? false : true,
                child: Column(
                  children: [

                    ReuseableWidget(title: 'Sub total', value: r'$' + value.getTotalPrice().toString()),

                    // ReuseableWidget(title: 'Discount 5%', value: r'$' + value.getTotalPrice().toString()),

                    // ReuseableWidget(title: 'Total', value: r'$' + value.getTotalPrice().toString()),
                  ],
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}