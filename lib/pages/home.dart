import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_service.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id:'1', name:'Metallica',votes: 5),
    // Band(id:'2', name:'Heroes del silencio',votes: 115),
    // Band(id:'3', name:'Queen',votes: 25),
    // Band(id:'4', name:'Bon Jovi',votes: 35),
  ];

  @override
  void initState() {
    
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ) {

    bands = (payload as List)
        .map( (band) => Band.fromMap(band) )
        .toList();

    setState(() {
    }) ;
    
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: ( socketService.serverStatus == ServerStatus.Online )
                  ? Icon( Icons.check_circle, color: Colors.blue[300] )
                  : Icon( Icons.offline_bolt, color: Colors.red ),
              ),

        ],
      ),
      body: Column(
        children: <Widget>[

          _showGraf(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index){
            
                return _bandTitle(bands[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: (){
          addNewBand();
      }),
    );
  }

  Widget _bandTitle(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),)),
      ),
      child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text( band.name.substring(0,2)),
            ),
            title: Text( band.name),
            trailing: Text('${band.votes}', style:  TextStyle(fontSize: 20)),
            onTap: (){
              socketService.socket.emit('vote-band', {'id': band.id});
              
            },
          ),
    );
  }


  addNewBand(){

    final textController = new TextEditingController();
    showDialog(
      context: context,
      builder: ( _ ) {
        return AlertDialog(
          title: Text('New band Name:'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5,
              textColor: Colors.blue,
              onPressed: (){
                addBandToList(textController.text);
              },
              child: Text('Add'),
            )
          ],
        );
      }
      );
  }

  void addBandToList( String name ){

    final socketService = Provider.of<SocketService>(context, listen: false);

    if(name.length >1){
      socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraf(){

    Map<String, double> dataMapa = new Map();

  // bands.forEach( (band) {
  //   if(band.name.isNotEmpty){
  //   dataMapa.putIfAbsent(band.name 
  //     , () => band.votes.toDouble());
  //   }
      
  // });

  for (var band in bands) {
   dataMapa.putIfAbsent(band.name, () => band.votes.toDouble());
  }



  // final List<Color> colorList = [
  //   Colors.blue[50]!,
  //   Colors.blue[200]!,
  //   Colors.pink[50]!,
  //   Colors.pink[200]!,
  // ];

    if (dataMapa == null || dataMapa.isEmpty) {
    return Center(
      child: Text('No hay datos disponibles para mostrar el gráfico'),
    );
  }


    return SizedBox(
      width: double.infinity,
      height: 100,
      child: PieChart(
        dataMap: dataMapa,
        chartType: ChartType.ring,),
    );
  }


}