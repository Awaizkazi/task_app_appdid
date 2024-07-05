import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealDetailsScreen extends StatefulWidget {
  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Map<String, dynamic>? mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final response = await http.get(
        Uri.parse('https://themealdb.com/api/json/v1/1/lookup.php?i=52959'));

    if (response.statusCode == 200) {
      setState(() {
        mealDetails = jsonDecode(response.body)['meals'][0];
      });
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
      ),
      body: Center(
        child: mealDetails == null
            ? const CircularProgressIndicator() // Display loading indicator while fetching data
            : mealDetailsCard(),
      ),
    );
  }

  Padding mealDetailsCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            mealDetails!['strMealThumb'],
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            mealDetails!['strMeal'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Category: ${mealDetails!['strCategory']}',
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Instructions:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            mealDetails!['strInstructions'],
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
