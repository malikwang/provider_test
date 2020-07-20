import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Provider Test'),
        ),
        body: Center(
          child: ParentWidget(),
        ),
      ),
    );
  }
}

class ParentModel with ChangeNotifier {
  final int initValue;
  ParentModel(this.initValue) {
    _value = initValue;
  }

  int _value;
  int get value => _value;

  ChildModel _childModel = ChildModel(1);
  ChildModel get childModel => _childModel;
  set childModel(ChildModel model) {
    _childModel = model;
    notifyListeners();
  }

  void increment() {
    _value += 1;
    notifyListeners();
  }
}

class ParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChildModel(1)),
        ChangeNotifierProxyProvider<ChildModel, ParentModel>(
          create: (_) => ParentModel(1),
          update: (_, childModel, parentModel) => parentModel..childModel = childModel,
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Consumer<ParentModel>(
            builder: (_, parentModel, child) {
              return Container(
                padding: EdgeInsets.all(20),
                color: Colors.blueAccent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Parent value: ${parentModel.value} \n Child value: ${parentModel.childModel.value}'),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          parentModel.increment();
                          parentModel.childModel.increment();
                        },
                        child: Text('Both Increment'),
                      ),
                    ),
                    ChildWidget(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChildModel with ChangeNotifier {
  final int initValue;
  ChildModel(this.initValue) {
    _value = initValue;
  }

  int _value;
  int get value => _value;

  void increment() {
    _value += 1;
    notifyListeners();
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChildModel>(
      builder: (_, childModel, child) {
        return Container(
          padding: EdgeInsets.all(20),
          color: Colors.yellowAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Child value: ${childModel.value}'),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  color: Colors.white,
                  onPressed: childModel.increment,
                  child: Text('Increment'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
