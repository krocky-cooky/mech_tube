import 'package:flutter/material.dart';
import 'package:mech_tube/screen/top_page_widgets.dart';
import 'package:mech_tube/model/user_model.dart';

class TopPage extends StatefulWidget{
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage>{
  int _currentTab = 0;
  List<Widget> _selectedWidget= [
    UserPage(
        user: taku,
    ),
    TrainingPage(),
    AnalyzePage()
  ];
  List<String> _selectedPageName = [
    'user page',
    'training',
    'analyze'
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageName[_currentTab]),
        backgroundColor: Colors.blue,
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          child: _selectedWidget[_currentTab]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int value){
          setState((){
            _currentTab = value;
          });
        },
        items : [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30.0
            ),
            title: Text('user page'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.fitness_center,
                size: 30.0
            ),
            title: Text('training'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.insert_chart,
                size: 30.0
            ),
            title: Text('analyze'),
          )
        ]
      ),
    );
  }
}