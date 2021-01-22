import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String answer;
  String answerTemp;
  String inputFull;

  /// Operator
  String op;
  bool calculateMode;

  @override
  void initState() {
    answer = "0";
    op = "";
    answerTemp = "";
    inputFull = "";
    calculateMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [_buildAnswerWidget(), buildNumPadWidget()],
      ),
    );
  }

  Widget _buildAnswerWidget() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(inputFull + " " + op, style: TextStyle(fontSize: 18)),
              Text(
                answer,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }

  Widget buildNumPadWidget() {
    return Column(
      children: [
        Row(children: [
          buildNumberButton("CE", numberButton: false, onTap: () {
            clearAnswer();
          }),
          buildNumberButton("C", numberButton: false, onTap: () {
            clearAll();
          }),
          buildNumberButton("⌫", numberButton: false, onTap: () {
            removeAnswerLast();
          }),
          buildNumberButton("÷", numberButton: false, onTap: () {
            addOperatorToAnswer("÷");
          }),
        ]),
        Row(children: [
          buildNumberButton("7", onTap: () {
            addNumberToAnswer(7);
          }),
          buildNumberButton("8", onTap: () {
            addNumberToAnswer(8);
          }),
          buildNumberButton("9", onTap: () {
            addNumberToAnswer(9);
          }),
          buildNumberButton("×", numberButton: false, onTap: () {
            addOperatorToAnswer("×");
          }),
        ]),
        Row(children: [
          buildNumberButton("4", onTap: () {
            addNumberToAnswer(4);
          }),
          buildNumberButton("5", onTap: () {
            addNumberToAnswer(5);
          }),
          buildNumberButton("6", onTap: () {
            addNumberToAnswer(6);
          }),
          buildNumberButton("−", numberButton: false, onTap: () {
            addOperatorToAnswer("-");
          }),
        ]),
        Row(children: [
          buildNumberButton("1", onTap: () {
            addNumberToAnswer(1);
          }),
          buildNumberButton("2", onTap: () {
            addNumberToAnswer(2);
          }),
          buildNumberButton("3", onTap: () {
            addNumberToAnswer(3);
          }),
          buildNumberButton("+", numberButton: false, onTap: () {
            addOperatorToAnswer("+");
          }),
        ]),
        Row(children: [
          buildNumberButton("±", numberButton: false, onTap: () {
            toggleNegative();
          }),
          buildNumberButton("0", onTap: () {
            addNumberToAnswer(0);
          }),
          buildNumberButton(".", numberButton: false, onTap: () {
            addDotToAnswer();
          }),
          buildNumberButton("=", numberButton: false, onTap: () {
            calculate();
          }),
        ]),
      ],
    );
  }

  toggleNegative() {
    setState(() {
      if (answer.contains("-")) {
        answer = answer.replaceAll("-", "");
      } else {
        answer = "-" + answer;
      }
    });
  }

  clearAnswer() {
    setState(() {
      answer = "0";
    });
  }

  clearAll() {
    setState(() {
      answer = "0";
      inputFull = "";
      calculateMode = false;
      op = "";
    });
  }

  calculate() {
    setState(() {
      if (calculateMode) {
        bool decimalMode = false;
        double value = 0;
        if (answer.contains(".") || answerTemp.contains(".")) {
          decimalMode = true;
        }

        if (op == "+") {
          value = (double.parse(answerTemp) + double.parse(answer));
        } else if (op == "-") {
          value = (double.parse(answerTemp) - double.parse(answer));
        } else if (op == "×") {
          value = (double.parse(answerTemp) * double.parse(answer));
        } else if (op == "÷") {
          value = (double.parse(answerTemp) / double.parse(answer));
        }

        if (!decimalMode) {
          answer = value.toInt().toString();
        } else {
          answer = value.toString();
        }

        calculateMode = false;
        op = "";
        answerTemp = "";
        inputFull = "";
      }
    });
  }

  addOperatorToAnswer(String secOp) {
    setState(() {
      if (answer != "0" && !calculateMode) {
        calculateMode = true;
        answerTemp = answer;
        inputFull += op + " " + answerTemp;
        op = secOp;
        answer = "0";
      } else if (calculateMode) {
        if (answer.isNotEmpty) {
          calculate();
          answerTemp = answer;
          inputFull = "";
          op = "";
        } else {
          op = secOp;
        }
      }
    });
  }

  addDotToAnswer() {
    setState(() {
      if (!answer.contains(".")) {
        answer = answer + ".";
      }
    });
  }

  addNumberToAnswer(int number) {
    setState(() {
      if (number == 0 && answer == "0") {
        //* Not do anything.
      } else if (number != 0 && answer == "0") {
        answer = number.toString();
      } else {
        answer += number.toString();
      }
    });
  }

  void removeAnswerLast() {
    if (answer == "0") {
      // Not do anything.
    } else {
      setState(() {
        if (answer.length > 1) {
          answer = answer.substring(0, answer.length - 1);
          if (answer.length == 1 && (answer == "." || answer == "-")) {
            answer = "0";
          }
        } else {
          answer = "0";
        }
      });
    }
  }

  Widget buildNumberButton(String str,
      {@required Function() onTap, bool numberButton = true}) {
    Widget widget;
    if (numberButton) {
      widget = Container(
        margin: EdgeInsets.all(1),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.blue,
            child: Container(
              height: 70,
              child: Center(
                child: Text(
                  str,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      widget = Container(
        margin: EdgeInsets.all(1),
        child: Material(
          color: Color(0xffecf0f1),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.blue,
            child: Container(
              height: 70,
              child: Center(
                child: Text(
                  str,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(child: widget);
  }
}
