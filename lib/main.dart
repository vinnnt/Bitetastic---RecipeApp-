import 'package:bitetastic/models/user.dart';
import 'package:bitetastic/screens/wrapper.dart';
import 'package:bitetastic/services/auth.dart';
import 'package:bitetastic/services/auth_notifier.dart';
import 'package:bitetastic/services/recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
  providers: [
     ChangeNotifierProvider(
      create: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => RecipeNotifier(),
    ),
  ],
  child: MyApp(),
));
  // runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
