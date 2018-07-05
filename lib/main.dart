import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

void main() {
  runApp(MainTabBar());
}

Future<Post> fetchPost() async {
  final response =
  await http.get('https://www.pnp.co.za/pnpstorefront/pnp/en/All-Products/Food-Cupboard/Rice%2C-Grains-%26-Maize/c/rice-grains-and-maize-487551153');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_balance_wallet)),
                Tab(icon: Icon(Icons.search)),
                Tab(icon: Icon(Icons.shopping_cart)),
                Tab(icon: Icon(Icons.history))
                ,
              ],
            ),
            title: Text('VMoney'),
          ),
          body: TabBarView(
            children: [
              new Column(
                children: <Widget>[
                  new Text('Deliver features faster'),
                  new Text('Craft beautiful UIs'),
                  new Expanded(
                    child: new FittedBox(
                      fit: BoxFit.contain, // otherwise the logo will be tiny
                      child: const FlutterLogo(),
                    ),
                  ),
                ],
              ),
          FutureBuilder<Post>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
              Icon(Icons.shopping_cart),
              Icon(Icons.history),
            ],
          ),
        ),
      ),
    );
  }
}