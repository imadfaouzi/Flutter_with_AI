import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String title;
  final String location;
  final String image;
  final String category;
  final String place;
  final String price;

  Activity({
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.place,
    required this.price,
  });

  // Factory method pour créer une instance d'Activity à partir d'un DocumentSnapshot
  factory Activity.fromSnapshot(DocumentSnapshot snapshot) {
    // Ici, 'snapshot' représente un document de Firestore
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Activity(
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      image: data['image'] ?? '',
      category: data['category'] ?? '',
      place: data['place'] ?? '',
      price: data['price'] ?? '',
    );
  }
}


//--------------
class ActivitesScreen extends StatefulWidget {
  @override
  _ActivitesScreenState createState() => _ActivitesScreenState();
}

class _ActivitesScreenState extends State<ActivitesScreen> {
  String selectedCategory = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Tous';
                  });
                },
                child: Text('Tous'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Sport';
                  });
                },
                child: Text('Sport'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Agriculture';
                  });
                },
                child: Text('Agriculture'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('activities').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Activity> activities = snapshot.data!.docs
                    .map((doc) => Activity.fromSnapshot(doc))
                    .where((activity) {
                  if (selectedCategory == 'Tous') {
                    return true;
                  } else {
                    return activity.category == selectedCategory;
                  }
                })
                    .toList();

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    Activity activity = activities[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                height: 400,
                                width: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(activity.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(activity.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text('Category: ${activity.category}'),
                                    Text('Place: ${activity.place}'),
                                    Text('Price: ${activity.price}'),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Fermer'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          children: [
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(activity.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                activity.title,
                                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                activity.category,
                                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                              ),
                              leading: Icon(Icons.event), // Icon added here
                            ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.event_seat), // Icon for Place
                                      SizedBox(width: 8),
                                      Text('Place: ${activity.place}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.money_off), // Icon for Price
                                      SizedBox(width: 8),
                                      Text('Price: ${activity.price}'),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.category), // Icon for Category
                                      SizedBox(width: 8),
                                      Text('Category: ${activity.category}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.title), // Icon for Title
                                      SizedBox(width: 8),
                                      Text('Title: ${activity.title}'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}