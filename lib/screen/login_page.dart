import 'package:flutter/material.dart';
import 'package:mech_tube/screen/top_page.dart';

class LoginPage extends StatelessWidget{
  List<String> links = [
    'Signin',
    'Login',
    'Configuration'
  ];

  Widget _buildButton(int index,BuildContext context){
    return RaisedButton(
      onPressed: (){
        Navigator.of(context).pushNamed(
          "/top",
        );
      },
      color: Colors.blue,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check,
          ),
          Text(
              links[index],
          style: TextStyle(
            color: Colors.white,
          ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    List<Widget> _linkButtons = [];
    for(var i = 0; i < links.length; ++i){
      _linkButtons.add(_buildButton(i,context));
    }
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0,horizontal: 100),
          child: Align(
            alignment: Alignment.bottomCenter,
            //color: Theme.of(context).accentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _linkButtons,
            )
          ),
        )
      ),
    );
  }
}
