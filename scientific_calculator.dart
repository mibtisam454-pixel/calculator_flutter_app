import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
class ScientificCalculator extends StatefulWidget {
  @override
  _ScientificCalculatorState createState() =>
      _ScientificCalculatorState();
}
class _ScientificCalculatorState extends State<ScientificCalculator> {
  String input = "";
  String output = "0";
  void onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        output = "0";
      } else if (value == "=") {
        calculate();
      } else if (value == "+/-") {
        if (input.isNotEmpty) {
          if (input.startsWith("-")) {
            input = input.substring(1);
          } else {
            input = "-" + input;
          }
        }
      } else {
        input += value;
      }
    });
  }
  void calculate() {
    try {
      String exp = input;
      exp = exp.replaceAll('×', '*');
      exp = exp.replaceAll('÷', '/');

      Parser p = Parser();
      Expression e = p.parse(exp);
      ContextModel cm = ContextModel();
      double result = e.evaluate(EvaluationType.REAL, cm);
      if (result % 1 == 0) {
        output = result.toInt().toString();
      } else {
        output = result.toString();
      }
    } catch (e) {
      output = "Error";
    }
    setState(() {});
  }
  Widget buildButton(String text) {
    Color textColor = Colors.grey;
    Color bgColor = Colors.white;
    if (text == "C") {
      textColor = Colors.orange;
    } else if (["÷", "×", "-", "+", "%"].contains(text)) {
      textColor = Colors.blue;
    } else if (text == "=") {
      bgColor = Colors.blue;
      textColor = Colors.white;
    }
    return Expanded(
      child: GestureDetector(
        onTap: () => onButtonClick(text),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 22,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildRow(List<String> buttons) {
    return Row(
      children: buttons.map((b) => buildButton(b)).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Calculator"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    output,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildRow(["C", "()", "%", "÷"]),
          buildRow(["7", "8", "9", "×"]),
          buildRow(["4", "5", "6", "-"]),
          buildRow(["1", "2", "3", "+"]),
          buildRow(["+/-", "0", ".", "="]),
        ],
      ),
    );
  }
}