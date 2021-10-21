import 'package:flutter/material.dart';
import 'package:mech_tube/model/user_model.dart';
import 'dart:io';


class UserPage extends StatelessWidget{
  User user;
  UserPage({
    this.user
});
  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 30.0,
            ),
            CircleAvatar(
              radius: 70.0,
              backgroundImage: AssetImage(user.imageUrl)
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(user.name),
            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Age:   '),
                Text(user.age.toString())
              ],
            ),
            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('max weight:   '),
                Text(user.maxWeight.toString())
              ],
            )
          ],
        ),
      )
    );
  }
}

class TrainingPage extends StatefulWidget{
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage>{
  var _currentWeight = 10.0;
  int _currentCount = 0;
  String message;
  int _trainingTypeIndex = 0;
  List<String> _trainingTypes = [
    'Arm curl',
    'Chest press',
    'Bench press'
  ];
  void _cratchManipulater(double value){
    double tmp = _currentWeight;
    setState((){
      _currentWeight = value.roundToDouble();
    });
    message = _currentWeight.toString();
    // print(message);
    Socket.connect('192.168.1.3',4041).then((socket) {
      if(_currentWeight <= 60 && tmp > 60){
        socket.write('95');
        print('send 95');
        socket.close();
      }else if(_currentWeight > 60 && tmp <= 60){
        socket.write('155');
        print('send 155');
        socket.close();
      }
    });

  }

  void _changeTrainingType(){
    int currentTrainingTypeIndex = _trainingTypeIndex;
    currentTrainingTypeIndex  = (currentTrainingTypeIndex + 1) % _trainingTypes.length;
    setState(() {
      _trainingTypeIndex = currentTrainingTypeIndex;
  });
  }
  @override
  Widget build(BuildContext context){
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 50),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 180,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20
                      ),
                      Text(
                        'Training Type',
                        style: TextStyle(
                          fontSize: 20
                        )
                        ),
                      Divider(
                        thickness: 2,
                      ),
                      Text(
                        _trainingTypes[_trainingTypeIndex],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(
                        height: 20
                      ),
                      ElevatedButton(
                        child: const Text('Change training type'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _changeTrainingType,
                      )
                    ]
                  )
                )
              )
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 180,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Weight Setting',
                        style: TextStyle(
                          fontSize: 20,
                        )
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Slider(
                        value: _currentWeight,
                        min: 10,
                        max: 80,
                        divisions: 90,
                        onChanged: _cratchManipulater,
                      ),
                      Text(
                        _currentWeight.toString() + ' kg',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 180,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Current Count',
                        style: TextStyle(
                          fontSize: 20,
                        )
                      ),
                      Divider(thickness: 2),
                      Text(
                        _currentCount.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        )
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class AnalyzePage extends StatefulWidget{
  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Text('analyze page'),
    );
  }
}