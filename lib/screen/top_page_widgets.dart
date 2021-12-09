import 'package:flutter/material.dart';
import 'package:mech_tube/model/user_model.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:convert';


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
  final FlutterBlue flutterblue = FlutterBlue.instance;
  final List<BluetoothDevice> deviceList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _TrainingPageState createState() => _TrainingPageState();
}


class _TrainingPageState extends State<TrainingPage>{
  double _currentWeightSlider = 0;
  double _currentWeight = 0.0;
  int _currentCount = 0;
  String deviceName = 'ESP32';
  BluetoothDevice _connectedDevice;
  String connection = 'not connected';
  List<BluetoothService> _services;
  bool isScanning;
  bool motorIsOn = false;
  int _trainingTypeIndex = 0;
  Timer _timer;
  int _timeToSend = 0;
  List<String> _trainingTypes = [
    'Arm curl',
    'Chest press',
    'Bench press'
  ];

  void _addDeviceTolist(final BluetoothDevice device){
    if(!widget.deviceList.contains(device)){
      setState(() {
        widget.deviceList.add(device);
      });
    }
  }



  void _sendWeight(){
    for(BluetoothService service in _services) {
      for(BluetoothCharacteristic characteristic in service.characteristics) {
        if(characteristic.properties.write) {
          String sendValues = "(t,$_currentWeight)";
          print("SEND WEIGHT !");
          characteristic.write(
              utf8.encode(sendValues));
        }
      }
    }
  }

  void _sendingTimer() {
    if(_timeToSend == -1)return;
    _timeToSend -= 1;
    if (_timeToSend == 0){
      _sendWeight();
    }
  }

  void _turnOnMotor() async {
    for (BluetoothService  service in _services){
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          String turnOnConverter = "(p,1)";
          String turnOnMotor = "(m,1)";
          await characteristic.write(utf8.encode(turnOnConverter));
          await characteristic.write(utf8.encode(turnOnMotor));
          setState(() {
            motorIsOn = true;
          });
        }
      }
    }
  }

  void _turnOffMotor() async {
    for (BluetoothService  service in _services){
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          String turnOffConverter = "(p,0)";
          await characteristic.write(utf8.encode(turnOffConverter));
          setState(() {
            motorIsOn = false;
          });
        }
      }
    }
  }

  void _changeTrainingType(){
    int currentTrainingTypeIndex = _trainingTypeIndex;
    currentTrainingTypeIndex  = (currentTrainingTypeIndex + 1) % _trainingTypes.length;
    setState(() {
      _trainingTypeIndex = currentTrainingTypeIndex;
    });
  }

  void _manageConnection(BluetoothDevice device) {
    device.state.listen((BluetoothDeviceState state){
      if (state == BluetoothDeviceState.disconnected){
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("device not found"),
              children: <Widget>[
                // コンテンツ領域
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text("デバイスとの接続が途切れました"),
                ),
              ],
            );
          },
        );
        setState(() {
          _connectedDevice = null;
        });
      }
    });
  }


  Column _buildButtonOrSlider(){
    if (motorIsOn){
      return Column(
          children: [
            Text(
                _currentWeight.toString(),
                style: TextStyle(
                  fontSize: 30,
                )
            ),
            Slider(
                value: _currentWeightSlider,
                min: 0,
                max: 50,
                divisions: 50,
                onChanged: (double value){
                  _timeToSend = 2;
                  setState((){
                    _currentWeightSlider = value.roundToDouble();
                    _currentWeight = value.roundToDouble() / 10;
                  });


                }
            ),
            ElevatedButton(
                child: const Text('turn off converter and motor'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _turnOffMotor
            ),
          ]
      );
    }
    return Column(
      children: [
        ElevatedButton(
          child: const Text('turn on converter and motor'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _turnOnMotor
        ),
      ],
    );

  }

  Widget _buildConnectionOrTrainingPage() {
    if (_connectedDevice != null){
      return Container(
        child: SingleChildScrollView(
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
                      height: 200,
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
                          _buildButtonOrSlider(),
                          Divider(
                            thickness: 2,
                          ),
                          Text(
                              connection,
                              style: TextStyle(
                                fontSize: 15,
                              )
                          )
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
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
          child: const Text(
              'Connect',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
          )),
    style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.black,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    onPressed: () async{
      print('pressed');
      widget.flutterblue.stopScan();
      bool flag = false;
      print(widget.deviceList.length);
      for (BluetoothDevice device in widget.deviceList){
          if(device.name == deviceName){
            flag = true;
            try{
              await device.connect();
            }catch (e){
              print('error occurred');
              if(e.code != 'already_connected'){
                throw e;
              }
            }finally{
              _services = await device.discoverServices();
              _manageConnection(device);
              setState(() {
                _connectedDevice = device;
                connection = 'connected';
              });
            }

          }

      }
      if(!flag) {
          connection = 'device not found';
          widget.flutterblue.startScan(timeout: Duration(seconds: 10));

          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("device not found"),
                children: <Widget>[
                  // コンテンツ領域
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Text("接続可能なデバイスが見つかりませんでした"),
                  ),
                ],
              );
            },
          );
      }else{
          connection = 'connect succeeded';
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("connect succeeded"),
                children: <Widget>[
                  // コンテンツ領域
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Text("接続に成功しました"),
                  ),
                ],
              );
            },
          );
      }
      flag = false;

    },),
        ),
      )
    );
  }

  @override
  void initState(){
    super.initState();
    new Timer.periodic(Duration(seconds: 1), (Timer t) => _sendingTimer());

    widget.flutterblue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
      for(BluetoothDevice device in devices){
        _addDeviceTolist(device);
        print('connected device = ' + (device.name == '' ? 'unknown device' : device.name));
      }
    });

    widget.flutterblue.scanResults.listen((List<ScanResult> results) {
      for(ScanResult result in results){
        _addDeviceTolist(result.device);
        print('scanresult device = ' + (result.device.name == '' ? 'unknown device' : result.device.name));
      }
    });

    widget.flutterblue.isScanning.listen((bool flag){
      isScanning = flag;
      if (flag) print('scanning');
      else {
        print('not scanning');
      }
    });
    widget.flutterblue.startScan(timeout: Duration(seconds: 10));
  }


  @override
  Widget build(BuildContext context){
    return _buildConnectionOrTrainingPage();
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