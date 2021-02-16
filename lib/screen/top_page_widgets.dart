import 'package:flutter/material.dart';
import 'package:mech_tube/model/user_model.dart';


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
                        max: 100,
                        divisions: 90,
                        onChanged: (double value){
                          setState((){
                            _currentWeight = value.roundToDouble();
                          });
                        }
                      ),
                      Text(
                        _currentWeight.toString(),
                        style: TextStyle(
                          fontSize: 30,
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