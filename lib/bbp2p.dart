import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

const String BLACKBOX_REQUEST_MSG = "<mTosp><data type='SVCBlackBoxRequest'></data></mTosp>";
const String BLACKBOX_REQUEST_MSG_JSON = "{\"type\" : \"request\", \"cmd\" : \"SVCBlackBoxRequest\"}";

const String MODEM_INFO_REQUEST_MSG_FOR_T10 = "<mTosp><data type='systemInfo'></data></mTosp>";
const String MODEM_INFO_REQUEST_MSG_FOR_T20 = "{\"type\" : \"request\", \"cmd\" : \"getDeviceInfo\", \"data\" : { \"timezone\" : \"+0900\", \"directFailReason\" : \"Y\", \"subCountryCode\" : \"\", \"regionalCode\" : \"\" }}";

const packetBeginByte = 0xAA;
const packetRequestLength = 0x06;

const packetDryer = 0x30;

const packetFrameID = 0xc8;
const packetSubFrameID = 0x00;
const packetEndByte = 0xBB;

class BlackBoxPeer2Peer {
  late String remoteAddress;
  late int port;
  late int timeout;
  late Socket clientSocket;

  List<int> modemInfoRequest = [123, 34, 116, 121, 112, 101, 34, 32, 58, 32, 34, 114, 101, 113, 117, 101, 115, 116, 34, 44, 32, 34, 99, 109, 100, 34, 32, 58, 32, 34, 103, 101, 116, 68, 101, 118, 105, 99, 101, 73, 110, 102, 111, 34, 44, 32, 34, 100, 97, 116, 97, 34, 32, 58, 32, 123, 32, 34, 116, 105, 109, 101, 122, 111, 110, 101, 34, 32, 58, 32, 34, 43, 48, 57, 48, 48, 34, 44, 32, 34, 100, 105, 114, 101, 99, 116, 70, 97, 105, 108, 82, 101, 97, 115, 111, 110, 34, 32, 58, 32, 34, 89, 34, 44, 32, 34, 115, 117, 98, 67, 111, 117, 110, 116, 114, 121, 67, 111, 100, 101, 34, 32, 58, 32, 34, 34, 44, 32, 34, 114, 101, 103, 105, 111, 110, 97, 108, 67, 111, 100, 101, 34, 32, 58, 32, 34, 34, 32, 125, 125];
  // List<int> modemInfoReceive = [1024*500];
  List<int> blackBoxRequest = [123, 34, 116, 121, 112, 101, 34, 32, 58, 32, 34, 114, 101, 113, 117, 101, 115, 116, 34, 44, 32, 34, 99, 109, 100, 34, 32, 58, 32, 34, 83, 86, 67, 66, 108, 97, 99, 107, 66, 111, 120, 82, 101, 113, 117, 101, 115, 116, 34, 125];

  BlackBoxPeer2Peer({
    this.remoteAddress = "192.168.120.254",
    this.port = 5500,
    this.timeout = 5,
  });

  void onListen(dynamic data) {
    // handle data from the server
    // final serverResponse = String.fromCharCodes(data);
    print('Server: $data');
  }

  requestDryer() async{
    print('modemInfoRequest : ${String.fromCharCodes(modemInfoRequest)}');
    print('blackBoxRequest : ${String.fromCharCodes(blackBoxRequest)}');

    // Stream<List<int>> stream = Stream.fromIterable([modemInfoRequest]);
    // Socket modemInfo = await clientSocket.addStream(stream);
    // stdin.listen((data) => connectedSocket.write(modemInfoRequest.toString() + 'n'));

    for (var charCode in modemInfoRequest) {
      clientSocket.writeCharCode(charCode);
    }
    //await Future.delayed(const Duration(seconds: 1));

    // String? getModemInfo = stdin.readLineSync();
    // debugPrint('getModemInfo : {$getModemInfo}');

    for (var charCode in blackBoxRequest) {
      clientSocket.writeCharCode(charCode);
    }

    await Future.delayed(const Duration(seconds: 1));

    // String? getBlackboxData = stdin.readLineSync();
    // debugPrint('getBlackboxData : {$getBlackboxData}');

    disconnectFromServer();


    //
    // byte[] msgByte = BLACKBOX_REQUEST_MSG_JSON.getBytes();
    // int nPayloadSize = msgByte.length;
    // ByteBuffer bytearray = ByteBuffer.allocate(nPayloadSize);
    // bytearray.put(msgByte);
    // publishProgress(CONN_STEP.REQUEST_BLACKBOX);
    // dos.write(bytearray.array(), 0, nPayloadSize);
    //

    // sendMessage(
    //   {"type":"response",
    //     "cmd":"getDeviceInfo",
    //     "data":
    //     {"protocolVer":"2.1",
    //       "mac":"44:cb:8b:cd:00:fd",
    //       "uuid":"fc853a52-1075-1bcb-9fe4-44cb8bcd00fd",
    //       "encrypt_val":"",
    //       "deviceType":"202",
    //       "modelName":"RH14_N_KR",
    //       "softwareVer":"2.9.66",
    //       "eepromChecksum":"0",
    //       "countryCode":"KR",
    //       "errorcodeDisplay":"0",
    //       "remainingTime":"420",
    //       "modemVer":"clip_hna_v1.9.052",
    //       "agentVer":"0"
    //     }}.toString()
    // );

    // List<int> msgByte = utf8.encode(BLACKBOX_REQUEST_MSG_JSON);//set Device Type

    // msgByte.addAll([packetBeginByte,packetRequestLength,packetDryer,packetFrameID,packetSubFrameID]);

    // clientSocket.add(msgByte);

    // clientSocket.add([packetBeginByte,packetRequestLength,packetDryer,packetFrameID,packetSubFrameID]);
    // print(clientSocket.flush());
    // clientSocket.add(new List<int>.generate(3, (int index) => index * index);
    // clientSocket.add('ASCII'.codeUnits);

        // clientSocket.write(BLACKBOX_REQUEST_MSG_JSON);
        // clientSocket.write(String.fromCharCodes([packetBeginByte,packetRequestLength,packetDryer,packetFrameID,packetSubFrameID]).trim());

    // );
  }

  // void sendMessage(String message) {
  //   clientSocket.write("$message\n");
  //   // clientSocket.addStream()
  // }

  void disconnectFromServer() {
    print("disconnectFromServer");
    clientSocket.close();
  }

  void onDone() {
    print("done connection");
    disconnectFromServer();
  }

  void onError(e) {
    print("onError: $e");
    disconnectFromServer();
  }

  void connectToServer() async {

    Socket.connect(remoteAddress, port, timeout: Duration(seconds: timeout))
        .then((socket) {

      clientSocket = socket;

      print("Connected to ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}");

      clientSocket.listen(
        onListen,
        onDone: onDone,
        onError: onError,
      );
    }).then((_) async{
      await requestDryer();
    }).catchError((e) {
      print(e.toString());
    });

  }
}