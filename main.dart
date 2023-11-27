import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String result = "0";
  bool shouldClearResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatResult(result),
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/"),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("*"),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-"),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("0"),
                buildButton("C"),
                buildButton("="),
                buildButton("+"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(text),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.all(20),
      ),
    );
  }

  void onButtonPressed(String text) {
    if (shouldClearResult) {
      // Clear the result if needed (after one calculation)
      setState(() {
        result = "0";
        shouldClearResult = false;
      });
    }

    if (text == "C") {
      // Clear the result
      setState(() {
        result = "0";
        shouldClearResult = false;
      });
    } else if (text == "=") {
      // Perform the calculation
      try {
        String expression = result.replaceAll("÷", "/").replaceAll("×", "*");
        Parser p = Parser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          result = formatResult(eval.toString());
          shouldClearResult = true; // Set flag to clear result after one calculation
        });
      } catch (e) {
        setState(() {
          result = "Error";
          shouldClearResult = true; // Set flag to clear result after one calculation
        });
      }
    } else {
      // Update the result
      setState(() {
        if (result == "0" || result == "Error" || shouldClearResult) {
          result = text;
          shouldClearResult = false;
        } else {
          result += text;
        }
      });
    }
  }

  String formatResult(String result) {
    // Remove decimal point if the result is an integer
    if (result.contains('.') && result.endsWith('0')) {
      return result.replaceAll(RegExp(r'\.0$'), '');
    }
    return result;
  }
}
