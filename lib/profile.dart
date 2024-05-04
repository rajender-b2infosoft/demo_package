import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/toggle_data_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  //Future<List<Category>>? categories;
  late Future<List<Category>>? categories_data;

  @override
  void initState() {
    super.initState();
    categories_data = getStoredData();
  }

  Future<List<Category>> getStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('jsonData');
    if (jsonData != null) {
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<Category> categories1 =
      jsonList.map((item) => Category.fromJson(item)).toList();
      return categories1;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categories_data, // Use the future in FutureBuilder
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          // Data is available
          List<Category>? categories = snapshot.data;
          // Check the values of categories here
          if (categories != null && categories.isNotEmpty) {
            print('++++++++++++++++++++++++++++++++++LLLLLLLLLLLLLLLLLL'); // Print the stored data
            print(categories); // Print the stored data
          } else {
            print('No data available'); // Handle empty data case
          }
          // Now you can build your UI using the categories data
          return Container(
            height: 600,
            child: ListView.builder(
              itemCount: categories?.length ?? 0,
              itemBuilder: (context, index) {
                Category data = categories![index];
                //toggleValues[index+1]=data.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.17,
                        child: Container(
                          child: CupertinoSwitch(
                            value: data.value,
                            //value: toggleValues[index+1],
                            onChanged: (val) {

                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              Text(
                                data.description,
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ); // Replace YourWidget with your actual UI widget
        }
      },
    );;
  }
}
