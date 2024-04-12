import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* 
Author : Sanjay Bhanushali
Purpose : This search widget will send the typed words to server to check whether the words exists in our db or not
Limitation : we are not implementing auto-completion , because server is created with the intention to search words
we need to save words in the app , if you want to get auto-completion word suggestion , then what will be the use of 
web server for word search. 
 */
class search_widget extends StatefulWidget {
  const search_widget({super.key});

  @override
  State<search_widget> createState() => _search_widgetState();
}

class _search_widgetState extends State<search_widget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextField(
      onChanged: (value) {
        // Call the sendSearchRequest function when the search term changes
        sendSearchRequest(value);
      },
      decoration: InputDecoration(
        hintText: 'Search...',
      ),
    ));
  }

  Future<void> sendSearchRequest(String searchTerm) async {
    print('sending search request');

    // Define the URL of your Python server
    var url = Uri.parse('http://127.0.0.1:5000/');

    // Define the data to be sent in the request body (in JSON format)
    var data = {'searchTerm': searchTerm};

    // Send the POST request
    var response = await http.post(
      url,
      body: data,
    );

    // Handle the response
    if (response.statusCode == 200) {
      print('Search request successful');
      print('Response body: ${response.body}');
      // You can process the response here
    } else {
      print('Failed to send search request. Error: ${response.statusCode}');
    }
  }
}
