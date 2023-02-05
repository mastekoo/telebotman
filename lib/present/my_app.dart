import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('teleBotMan'),
        ),
        body: NewRequest());
  }
}

class NewRequest extends StatefulWidget {
  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  bool isLoading = false;
  final _tokenController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  String _responseBody = '';
  String _host = '';
  String _port = '';

  void _updateHost(String text) {
    setState(() {
      _hostController.text = text;
    });
  }

  void _updatePort(String text) {
    setState(() {
      _portController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Enter bot token'),
            controller: _tokenController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Enter your Host'),
            controller: _hostController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Enter your port'),
            controller: _portController,
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            onPressed: () async {
              var value = _tokenController.text;
              var url = 'https://api.telegram.org/$value/getWebhookInfo';
              var response = await http.get(Uri.parse(url));
              if (response.statusCode == 200) {
                final parsedJson = json.decode(response.body);
                final getUrl = parsedJson['result']['url'];
                int index = getUrl.lastIndexOf(":");
                String port = getUrl.substring(index + 1);
                String host = getUrl.substring(0, index);
                setState(() => {_responseBody = response.body});
                setState(() {
                  _host = host.toString();
                });
                setState(() {
                  _port = port.toString();
                });
              } else {
                setState(() => {_responseBody = response.body});
              }
            },
            child: const Text('getWebhook')),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            onPressed: () {
              _updateHost(_host);
              _updatePort(_port);
            },
            child: const Text('paste')),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            onPressed: () async {
              var host = _hostController.text;
              var token = _tokenController.text;
              var port = _portController.text;
              var url =
                  'https://api.telegram.org/$token/setWebhook?url=$host:$port';
              var response = await http.get(Uri.parse(url));
              if (response.statusCode == 200) {
                setState(() => {_responseBody = response.body});
              } else {
                setState(() => {_responseBody = response.body});
              }
            },
            child: const Text('setWebhook')),
        Text(_responseBody)
      ],
    );
  }
}
