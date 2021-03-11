import 'package:lesson_5/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GenderList { male, female }

class FormValidation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FormValidationState();
}

class FormValidationState extends State {
  String _password_1;
  String _password_2;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GenderList _gender;
  bool _agreement = false;
  String name; // на примере этой переменной я пробовала перенести данные в Shared Preferences

  @override
  void initState(){
    name = UserPreferences().name;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Регистрация')),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child:  Form(
                key: _formKey,
                child:  Column(
                  children: <Widget>[
                    Text(
                      'Имя пользователя:',
                      //name ?? '', тут должна браться переменная name для Shared Preferences, но выдавало ошибку
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText:'Например: Иван',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Пожалуйста, введите свое имя';
                          }
                          else if(value.length>1){
                            return'Имя должно состоять из одного слова';
                          }
                          return null;
                        }),
                    SizedBox(height: 20.0),
                    Text(
                      'Номе телефона:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText:'+380...',
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Пожалуйста, введите свой номер телефна';
                          String t ="\^\\+?(38)?(0)?[0-9]{9}\$";
                          RegExp regExp = RegExp(t);
                          if (regExp.hasMatch(value)) return null;
                          return'Это не номер телефна';
                        }),
                    SizedBox(height: 20.0),
                    Text(
                      'Контактный E-mail:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText:'Например: ivan@gmail.com',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'Пожалуйста введите свой Email';
                          String p =
                              "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                          RegExp regExp =  RegExp(p);
                          if (regExp.hasMatch(value)) return null;
                          return 'Это не E-mail';
                        }),
                    Text(
                      'Пароль:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText:'Пароль должен содержать более 5 символов',
                        ),
                        validator: (value){
                          this._password_1 = value;
                          if (value.isEmpty) {return 'Пожалуйста введите свой пароль';}
                          else if(value.split('').length<5) {
                            return 'Пожалуйста введите пароль содержащий более 5 символов';
                          }
                          return null;
                        }),
                    Text(
                      'Повторно пароль:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(validator: (value){
                      this._password_2 = value;
                      if(this._password_1 != this._password_2) {  //не работает
                        return 'Пароли не совпадают';
                      }
                      return null;
                    }),
                    SizedBox(height: 20.0),
                    Text(
                      'Ваш пол:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    RadioListTile(
                      title: const Text('Мужской'),
                      value: GenderList.male,
                      groupValue: _gender,
                      onChanged: (GenderList value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Женский'),
                      value: GenderList.female,
                      groupValue: _gender,
                      onChanged: (GenderList value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    CheckboxListTile(
                        value: _agreement,
                        title:  Text('Я ознакомлен' +
                            (_gender == null
                                ? '(а)'
                                : _gender == GenderList.male
                                ? ''
                                : 'а') +
                            ' с документом "Согласие на обработку персональных данных" и даю согласие на обработку моих персональных данных в соответствии с требованиями "Федерального закона О персональных данных № 152-ФЗ".'),
                        onChanged: (bool value) => setState(() => _agreement = value)),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Color color = Colors.red;
                          String text;

                          if (_gender == null)
                            text = 'Выберите свой пол';
                          else if (_agreement == false)
                            text = 'Необходимо принять условия соглашения';
                          else {
                            text = 'Форма успешно заполнена';
                            color = Colors.green;
                          }

                          UserPreferences().name = name;
                          setState(() {
                            name = UserPreferences().name;
                          });

                          _scaffoldKey.currentState.hideCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(text),
                            backgroundColor: color,
                          ));
                        }
                      },
                      child: Text('Регистрация'),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ],
                ))),
      ),
    );
  }
}
