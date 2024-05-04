library network_permission;

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:network_permission/profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/toggle_data_model.dart';

class NetworkManagement extends StatefulWidget {
  const NetworkManagement({super.key});
  @override
  State<NetworkManagement> createState() => _NetworkManagementState();
}

class _NetworkManagementState extends State<NetworkManagement> {
  bool isSwitched= false;

  bool toggle_1=false;
  bool toggle_2=false;
  bool toggle_3=false;
  bool toggle_4=false;
  bool toggle_5=false;
  bool toggle_6=false;

  List<bool> toggleValues = [false, false, false, false, false, false]; // Initial values

  //Future<List<Category>>? categories;
  late Future<List<Category>>? categories2;

  @override
  void initState() {
    super.initState();
    readAndStoreData();
    categories2 = getStoredData();
  }

  Future<void> readAndStoreData() async {
    try {
      // Load JSON data from file
      final String jsonString = await rootBundle
          .loadString('packages/network_permission/assets/data.json');
      // Decode JSON data
      final jsonData = json.decode(jsonString);
      // Check if "categories" key exists in jsonData
      if (jsonData.containsKey('categories')) {

        print('---------------Key exist in json--------');
        // Extract list of categories
        List<dynamic> categoryList = jsonData['categories'];
        // Convert dynamic list to List<Category>
        List<Category> categories =
            categoryList.map((item) => Category.fromJson(item)).toList();
        // Store parsed data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jsonData', jsonEncode(categories));
      } else {
        throw Exception('JSON data format error: "categories" key not found');
      }
    } catch (e) {
      // Handle exceptions such as file not found or JSON parsing errors
      print('Error reading categories: $e');
    }
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

  Future<void> saveDataToSharedPreferences(List<Category> categories2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData =
        jsonEncode(categories2?.map((category) => category.toJson()).toList());

    prefs.setString('jsonData', jsonData);
    print('Saved data to SharedPreferences: $jsonData'); // Add this line for debugging
    // Update state after saving is complete
    //categories2 = getStoredData();
    // setState(() {
    //   //categories2 = getStoredData() as List<Category>;
    // });
  }

  void toggleAllSwitches(bool newValue) async {
    List<Category>? updatedCategories = await categories2;
    // Update all categories' values
    updatedCategories?.forEach((category) {
      category.value = newValue;
    });
    // Save updated values to SharedPreferences
    saveDataToSharedPreferences(updatedCategories!);
    // Update state to reflect changes
    setState(() {
      categories2 = Future.value(updatedCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Category>>(
        future: categories2,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            // Use snapshot.data to access the loaded categories
            // List<Category>? categories = snapshot.data;
            List<Category>? cat = snapshot.data;
            return SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                    height: height,
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.network_check_sharp,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 2,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                    child: const Text(" "),
                                  ),
                                  Container(
                                    width: 2,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                    child: const Text(" "),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "network",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40),
                              )
                            ],
                          ),
                          Container(
                            height: height,
                            child: ListView.builder(
                              itemCount: cat?.length ?? 0,
                              itemBuilder: (context, index) {
                                Category data = cat![index];
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
                                              // setState(() {
                                              //   toggleValues[index+1] = val;
                                              // });

                                              setState(() {
                                                cat?[index].value = val;
                                                saveDataToSharedPreferences(
                                                    cat);
                                                // cat![index] = Category(
                                                //   id: data.id,
                                                //   title: data.title,
                                                //   name: data.name,
                                                //   value: val,
                                                //   description: data.description,
                                                // );
                                              });
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.35,
                                height: 50,
                                child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Colors.black)),
                                    onPressed: () {
                                      setState(() {
                                        if(isSwitched){
                                          isSwitched = false;
                                        }else{
                                          isSwitched = true;
                                        }
                                      });
                                      toggleAllSwitches(isSwitched);
                                    },
                                    child: const Text(
                                      "TOGGLE ALL",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    )),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Container(
                                width: width * 0.35,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade100),
                                    onPressed: () {


                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Profile()),
                                      );


                                    },
                                    child: const Text(
                                      "UPDATE",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            );
          }
        });
  }
}
