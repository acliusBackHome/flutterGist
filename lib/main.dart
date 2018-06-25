import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'flutter-Gists',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new Gist(),
    );
  }
}

class Gist extends StatefulWidget {
  @override
  createState() => new GistState();
}

class GistState extends State<Gist> {
  var _gists;
  int _pos = -1;
  String _show = 'gists';
  final _url = 'https://api.github.com/gists/public';
  @override
  Widget build(BuildContext context) {
    print('build');
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text('flutter-gist'),
        ),
      ),
      body: new Center(
        child: new Text(_show),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _tabshow,
        tooltip: 'another one',
        child: new Icon(Icons.loop),
      ),
    );
  }
  void _tabshow() {
    if (_gists == null || _pos >= _gists.length ) {
      print(_pos);
      _getGist();
      return;
    }
    setState((){
      print(_pos);
      _show = _gists[_pos++]['description'];
      print(_show);
    });
  }
  _getGist() async {
    print('to get gists');
    final httpClient = new HttpClient();
    try {
      var req = await httpClient.getUrl(Uri.parse(_url));
      var res = await req.close();
      if (res.statusCode == HttpStatus.OK) {
        var json = await res.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        print(data);
        _gists = data;
      } else {
        _gists[0]['description'] = 'not Ok';
      }
    } catch(exception) {
      print('catch error!');
      _gists[0]['description'] = 'catch error';
    }
     _pos = 0;
     print(_gists);
    _tabshow();
  }
}