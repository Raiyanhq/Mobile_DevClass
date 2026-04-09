import 'package:flutter/material.dart';

import 'database_helper.dart';

final DatabaseHelper dbHelper = DatabaseHelper.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _insert() async {
    final Map<String, dynamic> row = <String, dynamic>{
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23,
    };
    final int id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final List<Map<String, dynamic>> allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final Map<String, dynamic> row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    final Map<String, dynamic> row = <String, dynamic>{
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32,
    };
    final int rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    final int id = await dbHelper.queryRowCount();
    final int rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  void _queryById() async {
    const int id = 1;
    final Map<String, dynamic>? row = await dbHelper.queryById(id);
    if (row == null) {
      debugPrint('no row found for id: $id');
      return;
    }
    debugPrint('query row $id: $row');
  }

  void _deleteAll() async {
    final int rowsDeleted = await dbHelper.deleteAll();
    debugPrint('deleted all rows: $rowsDeleted row(s)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _queryById,
              child: const Text('query by id'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAll,
              child: const Text('delete all'),
            ),
          ],
        ),
      ),
    );
  }
}
