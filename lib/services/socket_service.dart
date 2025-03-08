import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;


  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService(){
    _initConfig();
  }



  void _initConfig(){
      // Dart client
      // IO.Socket socket = IO.io('http://localhost:3000', {
      //   'transports': ['websocket'],
      //   'autoConnect': true
      // });

      _socket = IO.io('http://192.168.1.34:3000', 
      IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect()  // disable auto-connection
      .setExtraHeaders({'foo': 'bar'}) // optional
      .build()
      );
      _socket.connect();


      _socket.on('connect',(_) {

        _serverStatus = ServerStatus.Online;
        print(_serverStatus);
        print('connect');
        notifyListeners();
      });
    
      _socket.on('disconnect',(_) {
        _serverStatus = ServerStatus.Offline;
        print(_serverStatus);
        notifyListeners();
      });

      // socket.on('nuevo-mensaje', (payload){
      //       print('Nuevo mensaje del servidor:');
      //       print('Nombre: ' +payload['nombre']);
      //       print('Mensaje: ' +payload['mensaje']);
      //       print( payload.containsKey['mensaje2'] ? payload['mensaje2']: 'no hay');
      // });


  }
}