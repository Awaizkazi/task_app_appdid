import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_app_appdid/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
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
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryOfProduct()),
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
          : homeCategoryCard(),
    );
  }

  ListView homeCategoryCard() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
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
