import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:futurebuilder/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Builder',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder'),
        centerTitle: true,
      ),
      body: listHeroes(),
    );
  }

  Future<UserModel> getHeroes() async {
    final resp = await http.get('https://reqres.in/api/users');

    print(resp);
    return userModelFromJson(resp.body);
  }

  Widget listHeroes() {
    return FutureBuilder(
        future: getHeroes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _ListHeroes(snapshot.data.data, snapshot.data.ad);
          }
        });
  }
}

class _ListHeroes extends StatelessWidget {
  final List<Heroe> heroes;
  final Ad company;

  _ListHeroes(this.heroes, this.company);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: heroes.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
              title: Text(
                  '${heroes[i].firstName} ${heroes[i].lastName} ${company.company}'),
              subtitle: Text('${heroes[i].email}'),
              trailing: Image.network('${heroes[i].avatar}'));
        });
  }
}
