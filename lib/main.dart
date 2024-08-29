import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';

  void _onButtonPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculateResult() {
    try {
      final result = _evaluateExpression(_input);
      setState(() {
        _input = result.toString();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: Invalid input",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      setState(() {
        _input = '';
      });
    }
  }

  double _evaluateExpression(String expression) {
    try {
      final exp = Expression.parse(expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(exp, {});
      return result.toDouble();
    } catch (e) {
      throw Exception("Invalid Expression");
    }
  }

  void _clear() {
    setState(() {
      _input = '';
    });
  }

  void _backspace() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _input,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.4, // Adjust the height as needed
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                final buttons = [
                  '7',
                  '8',
                  '9',
                  '/',
                  '4',
                  '5',
                  '6',
                  '*',
                  '1',
                  '2',
                  '3',
                  '-',
                  'C',
                  '0',
                  '=',
                  '+',
                ];
                final button = buttons[index];
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (button == '=') {
                        _calculateResult();
                      } else if (button == 'C') {
                        _clear();
                      } else {
                        _onButtonPressed(button);
                      }
                    },
                    child: Text(
                      button,
                      style: TextStyle(fontSize: 24),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .grey[200], // Use backgroundColor instead of primary
                      padding: EdgeInsets.all(16.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
