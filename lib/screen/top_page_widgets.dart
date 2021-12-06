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
  double _currentWeight = 10.0;
  int _currentCount = 0;
  String deviceName = 'Hoge';
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;
  bool isScanning;
  int _trainingTypeIndex = 0;
  List<String> _trainingTypes = [
    'Arm curl',
    'Chest press',
    'Bench press'
  ];

  _addDeviceTolist(final BluetoothDevice device){
    if(!widget.deviceList.contains(device)){
      setState(() {
        widget.deviceList.add(device);
      });
    }
  }

  _sendWeight(){
    for(BluetoothService service in _services) {
      for(BluetoothCharacteristic characteristic in service.characteristics) {
        if(characteristic.properties.write) {
          List<int> sendValues = new List<int>();
          sendValues.add(_currentWeight.round());
          characteristic.write(sendValues);
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

  Column _buildButtonOrSlider(){
    if (_connectedDevice != null){
      return Column(
          children: [
            Slider(
                value: _currentWeight,
                min: 10,
                max: 100,
                divisions: 90,
                onChanged: (double value){
                  setState((){
                    _currentWeight = value.roundToDouble();
                  });
                  _sendWeight();

                }
            ),
            Text(
                _currentWeight.toString(),
                style: TextStyle(
                  fontSize: 30,
                )
            ),
          ]
      );
    }
    return Column(
      children: [
        ElevatedButton(
          child: const Text('Button'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async{
            await widget.flutterblue.stopScan();

            bool flag = false;
            for (BluetoothDevice device in widget.deviceList){
              if(device.name == deviceName){
                flag = true;
                try{
                  await device.connect();
                }catch (e){
                  if(e.code != 'already_connected'){
                    throw e;
                  }
                }finally{
                  _services = await device.discoverServices();
                  setState(() {
                    _connectedDevice = device;
                  });
                }

              }

            }
            if(!flag) {
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
            }

          },
        ),
      ],
    );

  }

  @override
  void initState(){
    super.initState();
    widget.flutterblue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
      for(BluetoothDevice device in devices){
        _addDeviceTolist(device);
      }
    });

    widget.flutterblue.scanResults.listen((List<ScanResult> results) {
      for(ScanResult result in results){
        _addDeviceTolist(result.device);
      }
    });

    widget.flutterblue.isScanning.listen((bool flag){
      isScanning = flag;
      if (flag) print('scanning');
      else {
        print('not scanning');
        if(_connectedDevice == null){
          widget.flutterblue.startScan();
      }
      }

    });
    widget.flutterblue.startScan();
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
                      _buildButtonOrSlider()
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