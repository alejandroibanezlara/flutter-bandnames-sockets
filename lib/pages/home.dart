import 'package:bandenames/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id:'1', name:'Metallica',votes: 5),
    Band(id:'2', name:'Heroes del silencio',votes: 115),
    Band(id:'3', name:'Queen',votes: 25),
    Band(id:'4', name:'Bon Jovi',votes: 35),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index){

          return _bandTitle(bands[index]);
        },
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
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
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
            onTap: (){},
          ),
    );
  }


  addNewBand(){

    final textController = new TextEditingController();
    showDialog(
      context: context, 
      builder: (context){
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
    if(name.length >1){
      this.bands.add( new Band(
        id: DateTime.now().toString(), 
        name: name, 
        votes: 0
        ));
      setState(() { });
    }

    Navigator.pop(context);
  }


}