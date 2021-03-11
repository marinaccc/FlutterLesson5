import 'package:flutter/material.dart';
import 'package:lesson_5/form__validation.dart';
import 'package:lesson_5/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson_5',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }

}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson 5')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10,),
            MaterialButton(
                child: Text('Регистрация'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return FormValidation();
                  }));
                }),
          ],
        ),
      ),
    );
  }
}
