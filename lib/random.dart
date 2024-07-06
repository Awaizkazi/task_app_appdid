import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomProductShow extends StatefulWidget {
  const RandomProductShow({super.key});

  @override
  RandomProductShowState createState() => RandomProductShowState();
}

class RandomProductShowState extends State<RandomProductShow> {
  Meal? meal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomMeal();
  }

  Future<void> fetchRandomMeal() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> mealList = data['meals'];

      setState(() {
        meal = Meal.fromJson(mealList[0]);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load meal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Product'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meal != null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            meal!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          meal!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal!.instructions,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No meal data')),
    );
  }
}

class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String instructions;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.instructions,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
      instructions: json['strInstructions'],
    );
  }
}
