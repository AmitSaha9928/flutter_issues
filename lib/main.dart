import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/issue/issue_bloc.dart';
import 'ui/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Issues App',
      home: BlocProvider(
        create: (context) => IssueBloc(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}
