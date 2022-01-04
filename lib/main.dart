// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io' show Platform, RawSocketOption, Socket;

import 'bbp2p.dart';

const String STA_DEFAULT_SSID = "STA_SSID";
const String STA_DEFAULT_PASSWORD = "STA_PASSWORD";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

const String AP_DEFAULT_SSID = "AP_SSID";
const String AP_DEFAULT_PASSWORD = "AP_PASSWORD";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _FlutterWifiIoTState createState() => _FlutterWifiIoTState();
}

class _FlutterWifiIoTState extends State<MyApp> {
  String? _sPreviousAPSSID = "";
  String? _sPreviousPreSharedKey = "";

  List<WifiNetwork?>? _htResultNetwork;
  Map<String, bool>? _htIsNetworkRegistered = Map();

  bool _isEnabled = false;
  bool _isConnected = false;
  bool _isWiFiAPEnabled = false;
  bool _isWiFiAPSSIDHidden = false;
  bool _isWifiAPSupported = true;
  bool _isWifiEnableOpenSettings = false;
  bool _isWifiDisableOpenSettings = false;


  final TextStyle textStyle = TextStyle(color: Colors.white);

  late Socket clientSocket;

  List<int> modemInfoRequest = [123, 34, 116, 121, 112, 101, 34, 32, 58, 32, 34, 114, 101, 113, 117, 101, 115, 116, 34, 44, 32, 34, 99, 109, 100, 34, 32, 58, 32, 34, 103, 101, 116, 68, 101, 118, 105, 99, 101, 73, 110, 102, 111, 34, 44, 32, 34, 100, 97, 116, 97, 34, 32, 58, 32, 123, 32, 34, 116, 105, 109, 101, 122, 111, 110, 101, 34, 32, 58, 32, 34, 43, 48, 57, 48, 48, 34, 44, 32, 34, 100, 105, 114, 101, 99, 116, 70, 97, 105, 108, 82, 101, 97, 115, 111, 110, 34, 32, 58, 32, 34, 89, 34, 44, 32, 34, 115, 117, 98, 67, 111, 117, 110, 116, 114, 121, 67, 111, 100, 101, 34, 32, 58, 32, 34, 34, 44, 32, 34, 114, 101, 103, 105, 111, 110, 97, 108, 67, 111, 100, 101, 34, 32, 58, 32, 34, 34, 32, 125, 125];
  // List<int> modemInfoReceive = [1024*500];
  List<int> blackBoxRequest = [123, 34, 116, 121, 112, 101, 34, 32, 58, 32, 34, 114, 101, 113, 117, 101, 115, 116, 34, 44, 32, 34, 99, 109, 100, 34, 32, 58, 32, 34, 83, 86, 67, 66, 108, 97, 99, 107, 66, 111, 120, 82, 101, 113, 117, 101, 115, 116, 34, 125];


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

  Future<bool> tryConnectSocket() async {
    /*Some Ip and Port that  can be connect to */
    String ip = "192.168.120.254";
    int port = 5500;

    try {
      // late RawSocketOption option ;
      // if (Platform.isAndroid) {
      //   option = RawSocketOption.fromBool(/* SOL_SOCKET */ 0x1, /* SO_KEEPALIVE */ 0x0009, true);
      // } else {
      //   option = RawSocketOption.fromBool(/* SOL_SOCKET */ 0xffff, /* SO_KEEPALIVE */ 0x0008, true);
      // }
      Socket s = await Socket.connect(ip, port, timeout: const Duration(seconds: 10)).timeout(const Duration(seconds: 10),
          onTimeout: () {
            log("ERROR ON SOCKET TIMEOUT");
            return Socket.connect(ip, port);
          }).catchError((e) {
        log("ERROR ON SOCKET $e");
        return Socket.connect(ip, port);
      }).onError((error, stackTrace) {
        log("ERROR ON SOCKET $error");
        return Socket.connect(ip, port);
      });

      s.listen((msg) {}, cancelOnError: false, onError: (e) {
        log("ERROR ON SOCKET $e");
      }, onDone: () {
        log("Socket DONE");
      });
      log("DONE");
      return true;
    } catch (e) {
      log("ERROR ON LISTENING TO SOCKET $e");
      return false;
    }
  }



  @override
  initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      _isConnected = val;
    });

    WiFiForIoTPlugin.isWiFiAPEnabled().then((val) {
      _isWiFiAPEnabled = val;
    }).catchError((val) {
      _isWifiAPSupported = false;
    });

    super.initState();
  }

  storeAndConnect(String psSSID, String psKey) async {
    await storeAPInfos();
    await WiFiForIoTPlugin.setWiFiAPSSID(psSSID);
    await WiFiForIoTPlugin.setWiFiAPPreSharedKey(psKey);
  }

  storeAPInfos() async {
    String? sAPSSID;
    String? sPreSharedKey;

    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on PlatformException {
      sAPSSID = "";
    }

    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on PlatformException {
      sPreSharedKey = "";
    }

    setState(() {
      _sPreviousAPSSID = sAPSSID;
      _sPreviousPreSharedKey = sPreSharedKey;
    });
  }

  restoreAPInfos() async {
    WiFiForIoTPlugin.setWiFiAPSSID(_sPreviousAPSSID!);
    WiFiForIoTPlugin.setWiFiAPPreSharedKey(_sPreviousPreSharedKey!);
  }

  // [sAPSSID, sPreSharedKey]
  Future<List<String>> getWiFiAPInfos() async {
    String? sAPSSID;
    String? sPreSharedKey;

    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on Exception {
      sAPSSID = "";
    }

    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on Exception {
      sPreSharedKey = "";
    }

    return [sAPSSID!, sPreSharedKey!];
  }

  Future<WIFI_AP_STATE?> getWiFiAPState() async {
    int? iWiFiState;

    WIFI_AP_STATE? wifiAPState;

    try {
      iWiFiState = await WiFiForIoTPlugin.getWiFiAPState();
    } on Exception {
      iWiFiState = WIFI_AP_STATE.WIFI_AP_STATE_FAILED.index;
    }

    if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_DISABLING.index) {
      wifiAPState = WIFI_AP_STATE.WIFI_AP_STATE_DISABLING;
    } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_DISABLED.index) {
      wifiAPState = WIFI_AP_STATE.WIFI_AP_STATE_DISABLED;
    } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_ENABLING.index) {
      wifiAPState = WIFI_AP_STATE.WIFI_AP_STATE_ENABLING;
    } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_ENABLED.index) {
      wifiAPState = WIFI_AP_STATE.WIFI_AP_STATE_ENABLED;
    } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_FAILED.index) {
      wifiAPState = WIFI_AP_STATE.WIFI_AP_STATE_FAILED;
    }

    return wifiAPState!;
  }

  Future<List<APClient>> getClientList(
      bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;

    try {
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } on PlatformException {
      htResultClient = <APClient>[];
    }

    return htResultClient;
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = <WifiNetwork>[];
    }

    return htResultNetwork;
  }

  isRegisteredWifiNetwork(String ssid) async {
    bool bIsRegistered;

    try {
      bIsRegistered = await WiFiForIoTPlugin.isRegisteredWifiNetwork(ssid);
    } on PlatformException {
      bIsRegistered = false;
    }

    setState(() {
      _htIsNetworkRegistered![ssid] = bIsRegistered;
    });
  }

  void showClientList() async {
    /// Refresh the list and show in console
    getClientList(false, 300).then((val) => val.forEach((oClient) {
      print("************************");
      print("Client :");
      print("ipAddr = '${oClient.ipAddr}'");
      print("hwAddr = '${oClient.hwAddr}'");
      print("device = '${oClient.device}'");
      print("isReachable = '${oClient.isReachable}'");
      print("************************");
    }));
  }

  Widget getWidgets() {
    WiFiForIoTPlugin.isConnected().then((val) {
      setState(() {
        _isConnected = val;
      });
    });

    // disable scanning for ios as not supported
    if (_isConnected || Platform.isIOS) {
      _htResultNetwork = null;
    }

    if (_htResultNetwork != null && _htResultNetwork!.length > 0) {
      final List<ListTile> htNetworks = <ListTile>[];

      _htResultNetwork!.forEach((oNetwork) {
        final PopupCommand oCmdConnect =
        PopupCommand("Connect", oNetwork!.ssid!);
        final PopupCommand oCmdRemove = PopupCommand("Remove", oNetwork.ssid!);

        final List<PopupMenuItem<PopupCommand>> htPopupMenuItems = [];

        htPopupMenuItems.add(
          PopupMenuItem<PopupCommand>(
            value: oCmdConnect,
            child: const Text('Connect'),
          ),
        );

        setState(() {
          isRegisteredWifiNetwork(oNetwork.ssid!);
          if (_htIsNetworkRegistered!.containsKey(oNetwork.ssid) &&
              _htIsNetworkRegistered![oNetwork.ssid]!) {
            htPopupMenuItems.add(
              PopupMenuItem<PopupCommand>(
                value: oCmdRemove,
                child: const Text('Remove'),
              ),
            );
          }

          htNetworks.add(
            ListTile(
              title: Text("" +
                  oNetwork.ssid! +
                  ((_htIsNetworkRegistered!.containsKey(oNetwork.ssid) &&
                      _htIsNetworkRegistered![oNetwork.ssid]!)
                      ? " *"
                      : "")),
              trailing: PopupMenuButton<PopupCommand>(
                padding: EdgeInsets.zero,
                onSelected: (PopupCommand poCommand) {
                  switch (poCommand.command) {
                    case "Connect":
                      String _password = oNetwork.ssid!.substring(oNetwork.ssid!.length - 4, oNetwork.ssid!.length) + oNetwork.ssid!.substring(oNetwork.ssid!.length - 4, oNetwork.ssid!.length);
                      print(_password);
                      WiFiForIoTPlugin.connect(
                          oNetwork.ssid.toString(),
                          password: _password,
                          joinOnce: true,
                          security: STA_DEFAULT_SECURITY);
                      break;
                    case "Remove":
                      WiFiForIoTPlugin.removeWifiNetwork(poCommand.argument);
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => htPopupMenuItems,
              ),
            ),
          );
        });
      });

      return ListView(
        padding: kMaterialListPadding,
        children: htNetworks,
      );
    } else {
      return SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: Platform.isIOS
                ? getButtonWidgetsForiOS()
                : getButtonWidgetsForAndroid(),
          ),
        ),
      );
    }
  }

  List<Widget> getButtonWidgetsForAndroid() {
    final List<Widget> htPrimaryWidgets = <Widget>[];

    WiFiForIoTPlugin.isEnabled().then((val) {
      setState(() {
        _isEnabled = val;
      });
    });

    if (_isEnabled) {
      htPrimaryWidgets.addAll([
        SizedBox(height: 10),
        Text("Wifi Enabled"),
        MaterialButton(
          color: Colors.blue,
          child: Text("Disable", style: textStyle),
          onPressed: () {
            WiFiForIoTPlugin.setEnabled(false,
                shouldOpenSettings: _isWifiDisableOpenSettings);
          },
        ),
      ]);

      WiFiForIoTPlugin.isConnected().then((val) {
        setState(() {
          _isConnected = val;
        });
      });

      if (_isConnected) {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Connected"),
          FutureBuilder(
              future: WiFiForIoTPlugin.getSSID(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String?> ssid) {
                return Text("SSID: ${ssid.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getBSSID(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String?> bssid) {
                return Text("BSSID: ${bssid.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getCurrentSignalStrength(),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int?> signal) {
                return Text("Signal: ${signal.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getFrequency(),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int?> freq) {
                return Text("Frequency : ${freq.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getIP(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String?> ip) {
                return Text("IP : ${ip.data}");
              }),
          MaterialButton(
            color: Colors.blue,
            child: Text("Disconnect", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.disconnect();
            },
          ),
          MaterialButton(
            color: Colors.blue,
            child: Text("socket test", style: textStyle),
            onPressed: () async{

              await tryConnectSocket();



              // BlackBoxPeer2Peer bb2p = BlackBoxPeer2Peer();
              // bb2p.connectToServer();
            },
          ),
          CheckboxListTile(
              title: const Text("Disable WiFi on settings"),
              subtitle: const Text("Available only on android API level >= 29"),
              value: _isWifiDisableOpenSettings,
              onChanged: (bool? setting) {
                if (setting != null) {
                  setState(() {
                    _isWifiDisableOpenSettings = setting;
                  });
                }
              })
        ]);
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Disconnected"),
          MaterialButton(
            color: Colors.blue,
            child: Text("Scan", style: textStyle),
            onPressed: () async {
              _htResultNetwork = await loadWifiList();
              setState(() {});
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.blue,
                child: Text("Use WiFi", style: textStyle),
                onPressed: () {
                  WiFiForIoTPlugin.forceWifiUsage(true);
                },
              ),
              SizedBox(width: 50),
              MaterialButton(
                color: Colors.blue,
                child: Text("Use 3G/4G", style: textStyle),
                onPressed: () {
                  WiFiForIoTPlugin.forceWifiUsage(false);
                },
              ),
            ],
          ),
          CheckboxListTile(
              title: const Text("Disable WiFi on settings"),
              subtitle: const Text("Available only on android API level >= 29"),
              value: _isWifiDisableOpenSettings,
              onChanged: (bool? setting) {
                if (setting != null) {
                  setState(() {
                    _isWifiDisableOpenSettings = setting;
                  });
                }
              })
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        SizedBox(height: 10),
        Text("Wifi Disabled"),
        MaterialButton(
          color: Colors.blue,
          child: Text("Enable", style: textStyle),
          onPressed: () {
            setState(() {
              WiFiForIoTPlugin.setEnabled(true,
                  shouldOpenSettings: _isWifiEnableOpenSettings);
            });
          },
        ),
        CheckboxListTile(
            title: const Text("Enable WiFi on settings"),
            subtitle: const Text("Available only on android API level >= 29"),
            value: _isWifiEnableOpenSettings,
            onChanged: (bool? setting) {
              if (setting != null) {
                setState(() {
                  _isWifiEnableOpenSettings = setting;
                });
              }
            })
      ]);
    }

    htPrimaryWidgets.add(Divider(
      height: 32.0,
    ));

    if (_isWifiAPSupported) {
      htPrimaryWidgets.addAll(<Widget>[
        Text("WiFi AP State"),
        FutureBuilder(
            future: getWiFiAPState(),
            initialData: WIFI_AP_STATE.WIFI_AP_STATE_DISABLED,
            builder: (BuildContext context,
                AsyncSnapshot<WIFI_AP_STATE?> wifiState) {
              final List<Widget> widgets = [];

              if (wifiState.data == WIFI_AP_STATE.WIFI_AP_STATE_ENABLED) {
                widgets.add(MaterialButton(
                  color: Colors.blue,
                  child: Text("Get Client List", style: textStyle),
                  onPressed: () {
                    showClientList();
                  },
                ));
              }

              widgets.add(Text(wifiState.data.toString()));

              return Column(children: widgets);
            }),
      ]);

      WiFiForIoTPlugin.isWiFiAPEnabled()
          .then((val) => setState(() {
        _isWiFiAPEnabled = val;
      }))
          .catchError((val) {
        _isWiFiAPEnabled = false;
      });

      if (_isWiFiAPEnabled) {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Wifi AP Enabled"),
          MaterialButton(
            color: Colors.blue,
            child: Text("Disable", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.setWiFiAPEnabled(false);
            },
          ),
        ]);
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Wifi AP Disabled"),
          MaterialButton(
            color: Colors.blue,
            child: Text("Enable", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.setWiFiAPEnabled(true);
            },
          ),
        ]);
      }

      WiFiForIoTPlugin.isWiFiAPSSIDHidden()
          .then((val) => setState(() {
        _isWiFiAPSSIDHidden = val;
      }))
          .catchError((val) => _isWiFiAPSSIDHidden = false);
      if (_isWiFiAPSSIDHidden) {
        htPrimaryWidgets.add(Text("SSID is hidden"));
        !_isWiFiAPEnabled
            ? MaterialButton(
          color: Colors.blue,
          child: Text("Show", style: textStyle),
          onPressed: () {
            WiFiForIoTPlugin.setWiFiAPSSIDHidden(false);
          },
        )
            : Container(width: 0, height: 0);
      } else {
        htPrimaryWidgets.add(Text("SSID is visible"));
        !_isWiFiAPEnabled
            ? MaterialButton(
          color: Colors.blue,
          child: Text("Hide", style: textStyle),
          onPressed: () {
            WiFiForIoTPlugin.setWiFiAPSSIDHidden(true);
          },
        )
            : Container(width: 0, height: 0);
      }

      FutureBuilder(
          future: getWiFiAPInfos(),
          initialData: <String>[],
          builder: (BuildContext context, AsyncSnapshot<List<String>> info) {
            htPrimaryWidgets.addAll(<Widget>[
              Text("SSID : ${info.data![0]}"),
              Text("KEY  : ${info.data![1]}"),
              MaterialButton(
                color: Colors.blue,
                child: Text(
                    "Set AP info ($AP_DEFAULT_SSID/$AP_DEFAULT_PASSWORD)",
                    style: textStyle),
                onPressed: () {
                  storeAndConnect(AP_DEFAULT_SSID, AP_DEFAULT_PASSWORD);
                },
              ),
              Text("AP SSID stored : $_sPreviousAPSSID"),
              Text("KEY stored : $_sPreviousPreSharedKey"),
              MaterialButton(
                color: Colors.blue,
                child: Text("Store AP infos", style: textStyle),
                onPressed: () {
                  storeAPInfos();
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text("Restore AP infos", style: textStyle),
                onPressed: () {
                  restoreAPInfos();
                },
              ),
            ]);

            return Text("SSID : ${info.data![0]}");
          });
    } else {
      htPrimaryWidgets.add(
          Center(child: Text("Wifi AP probably not supported by your device")));
    }

    return htPrimaryWidgets;
  }

  List<Widget> getButtonWidgetsForiOS() {
    final List<Widget> htPrimaryWidgets = <Widget>[];

    WiFiForIoTPlugin.isEnabled().then((val) => setState(() {
      _isEnabled = val;
    }));

    if (_isEnabled) {
      htPrimaryWidgets.add(Text("Wifi Enabled"));
      WiFiForIoTPlugin.isConnected().then((val) => setState(() {
        _isConnected = val;
      }));

      String? _sSSID;

      if (_isConnected) {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Connected"),
          FutureBuilder(
              future: WiFiForIoTPlugin.getSSID(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String?> ssid) {
                _sSSID = ssid.data;

                return Text("SSID: ${ssid.data}");
              }),
        ]);

        if (_sSSID == STA_DEFAULT_SSID) {
          htPrimaryWidgets.addAll(<Widget>[
            MaterialButton(
              color: Colors.blue,
              child: Text("Disconnect", style: textStyle),
              onPressed: () {
                WiFiForIoTPlugin.disconnect();
              },
            ),
          ]);
        } else {
          htPrimaryWidgets.addAll(<Widget>[
            MaterialButton(
              color: Colors.blue,
              child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
              onPressed: () {
                WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                    password: STA_DEFAULT_PASSWORD,
                    joinOnce: true,
                    security: NetworkSecurity.WPA);
              },
            ),
          ]);
        }
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Disconnected"),
          MaterialButton(
            color: Colors.blue,
            child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                  password: STA_DEFAULT_PASSWORD,
                  joinOnce: true,
                  security: NetworkSecurity.WPA);
            },
          ),
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        Text("Wifi Disabled?"),
        MaterialButton(
          color: Colors.blue,
          child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
          onPressed: () {
            WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                password: STA_DEFAULT_PASSWORD,
                joinOnce: true,
                security: NetworkSecurity.WPA);
          },
        ),
      ]);
    }

    return htPrimaryWidgets;
  }

  @override
  Widget build(BuildContext poContext) {
    return MaterialApp(
      title: Platform.isIOS
          ? "WifiFlutter Example iOS"
          : "WifiFlutter Example Android",
      home: Scaffold(
        appBar: AppBar(
          title: Platform.isIOS
              ? Text('WifiFlutter Example iOS')
              : Text('WifiFlutter Example Android'),
          actions: _isConnected
              ? <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case "disconnect":
                    WiFiForIoTPlugin.disconnect();
                    break;
                  case "remove":
                    WiFiForIoTPlugin.getSSID().then((val) =>
                        WiFiForIoTPlugin.removeWifiNetwork(val!));
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  value: "disconnect",
                  child: const Text('Disconnect'),
                ),
                PopupMenuItem<String>(
                  value: "remove",
                  child: const Text('Remove'),
                ),
              ],
            ),
          ]
              : null,
        ),
        body: getWidgets(),
      ),
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}