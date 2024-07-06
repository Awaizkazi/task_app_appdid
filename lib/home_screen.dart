import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_app_appdid/categories.dart';
import 'package:task_app_appdid/random.dart';

import 'meal_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Category> displayList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];

      setState(() {
        categories =
            categoryList.map((json) => Category.fromJson(json)).toList();
        displayList = List.from(categories);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

//!
  void onSearch(String value) {
    setState(() {
      displayList = categories
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: onSearch,
          decoration: const InputDecoration(hintText: 'Search an item'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RandomProductShow()),
              );
            },
            icon: const Icon(
              Icons.shuffle,
            ),
          ),
        ],
        elevation: 4,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeCategory(),
    );
  }

  ListView homeCategory() {
    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final category = displayList[index];
        return Card(
          elevation: 2,
          // TODO We can use Column bcwz there is only three fields Image,itemname, and Description so i use card here.
          child: ListTile(
            leading: Image.network(category.imageUrl),
            title: Text(
              'ItemName: ${category.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Description: ${category.description}'),
          ),
        );
      },
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'],
      name: json['strCategory'],
      description: json['strCategoryDescription'],
      imageUrl: json['strCategoryThumb'],
    );
  }
}
