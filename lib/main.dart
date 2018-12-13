import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(PrimeFactorizerApp());

class PrimeFactorizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prime Factorizer',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: [
          Colors.purple,
          Colors.pink,
          Colors.amber,
          Colors.deepPurple,
          Colors.deepOrange,
          Colors.brown,
          Colors.blue,
          Colors.blueGrey,
          Colors.cyan,
          Colors.green,
          Colors.grey,
          Colors.indigo,
          Colors.lightGreen,
          Colors.orange,
          Colors.teal,
          Colors.red
        ][Random().nextInt(16)],
      ),
      home: HomePage(title: 'Prime Factorizer'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int STATE_COMPUTING = 1;
  static const int STATE_FREE = 0;
  static int state = STATE_FREE;
  static BigInt number = BigInt.from(-1);
  static double progress = 0;

  String _result = "";

  final controller = TextEditingController();

  void _present(BigInt n) async {
    setState(() {
      state = STATE_COMPUTING;
    });

    number = n;
    String result = await compute(asyncPrimeFactorizer, n);

    setState(() {
      _result = result;
      state = STATE_FREE;
    });
  }

  /*void _streamPresent(BigInt n) async {
    setState(() {
      state = STATE_COMPUTING;
      _result = "Prime factors: ";
    });

    BigInt product = BigInt.from(1);

    await for (BigInt retrievedInt in streamPrimeFactorizer(n)) {
      product *= retrievedInt;
      setState(() {
        state = STATE_COMPUTING;
        _result += retrievedInt.toString() + ", ";
        progress = product / n;
      });
    }

    //BigInt retrievedInt = await stream.next;

    //while (retrievedInt != BigInt.from(STOP_CODE)) {
    //  setState(() {
    //    state = STATE_COMPUTING;
    //    _result += retrievedInt.toString() + ", ";
    //    progress = product / n;
    //  });
    //  product *= retrievedInt;
    //  retrievedInt = await stream.next;
    //}

    setState(() {
      state = STATE_FREE;
      _result = _result.substring(0, _result.length - 2);
    });
  }

  Stream<BigInt> streamPrimeFactorizer(BigInt n) async* {
    while (n % BigInt.from(2) == BigInt.from(0)) {
      yield BigInt.from(2);
      n = n ~/ BigInt.from(2);
    }

    for (int i = 3; BigInt.from(i) < sqrt(n) + BigInt.from(1); i = i + 2) {
      while (n % BigInt.from(i) == BigInt.from(0)) {
        yield BigInt.from(i);
        n = n ~/ BigInt.from(i);
      }
    }

    if (n > BigInt.from(2)) {
      yield n;
    }
  }*/

  static String asyncPrimeFactorizer(BigInt n) {
    String stringResult = "Prime factors: ";
    List<BigInt> factors = [];

    while (n % BigInt.from(2) == BigInt.from(0)) {
      factors.add(BigInt.from(2));
      n = n ~/ BigInt.from(2);
    }

    for (int i = 3; BigInt.from(i) < sqrt(n) + BigInt.from(1); i = i + 2) {
      while (n % BigInt.from(i) == BigInt.from(0)) {
        factors.add(BigInt.from(i));
        n = n ~/ BigInt.from(i);
      }
    }

    if (n > BigInt.from(2)) {
      factors.add(n);
    }

    for (int i = 0; i < factors.length; i++) {
      stringResult +=
          factors[i].toString() + ((i + 1 == factors.length) ? "" : ", ");
    }

    return stringResult;
  }

  static BigInt newtonIteration(BigInt n, BigInt x0) {
    final BigInt x1 = (BigInt.from(n / x0) + x0) >> 1;
    return x0 == x1 || x0 == (x1 - BigInt.from(1))
        ? x0
        : newtonIteration(n, x1);
  }

  static BigInt sqrt(final BigInt number) {
    if (number < BigInt.from(0))
      throw new Exception(
          "We can only calculate the square root of positive numbers.");
    return newtonIteration(number, BigInt.from(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 16.0),
                        child: Text(
                          'Enter an integer to find it\'s prime factors',
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(hintText: 'Your number...'))),
                    (state == STATE_COMPUTING)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 17.0,
                                left: 12.0,
                                right: 12.0,
                                top: 5.0),
                            child: LinearProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 12.0, right: 12.0),
                            child: Text(
                              _result,
                              style: Theme.of(context).textTheme.body2,
                              textAlign: TextAlign.center,
                            )),
                  ],
                )),
            RaisedButton(
              onPressed: () => _present(BigInt.parse(controller.text)),
              child: Text("CALCULATE"),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentTextTheme.button.color,
              textTheme: Theme.of(context).buttonTheme.textTheme,
            )
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _present(BigInt.parse(controller.text)),
        tooltip: 'Calculate',
        child: Icon(Icons.functions),
      ),*/
    );
  }
}
