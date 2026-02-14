import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: CalculatorScreen(
        isDark: isDark,
        onToggleTheme: () => setState(() => isDark = !isDark),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const CalculatorScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String activeOperator = '';
  double firstNumber = 0;
  bool shouldClear = false;

  void onPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        activeOperator = '';
        firstNumber = 0;
        shouldClear = false;
      } else if (['+', '-', '×', '÷'].contains(value)) {
        firstNumber = double.parse(display);
        activeOperator = value;
        shouldClear = true;
      } else if (value == '=') {
        double secondNumber = double.parse(display);
        double result = 0;

        switch (activeOperator) {
          case '+':
            result = firstNumber + secondNumber;
            break;
          case '-':
            result = firstNumber - secondNumber;
            break;
          case '×':
            result = firstNumber * secondNumber;
            break;
          case '÷':
            result = secondNumber != 0 ? firstNumber / secondNumber : 0;
            break;
        }

        display = result.toString().endsWith('.0')
            ? result.toStringAsFixed(0)
            : result.toString();

        activeOperator = '';
      } else {
        if (display == '0' || shouldClear) {
          display = value;
          shouldClear = false;
        } else {
          display += value;
        }
      }
    });
  }

  Widget calcButton(
    String text, {
    bool isOperator = false,
    bool isActive = false,
  }) {
    final Color baseColor = isOperator
        ? Colors.orange
        : widget.isDark
            ? const Color(0xFF1F1F1F)
            : Colors.white;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => onPressed(text),
          child: AnimatedScale(
            scale: isActive ? 0.92 : 1,
            duration: const Duration(milliseconds: 120),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isActive
                    ? baseColor.withOpacity(0.9)
                    : baseColor.withOpacity(0.7),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: baseColor.withOpacity(0.8),
                      blurRadius: 18,
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(3, 3),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isOperator
                      ? Colors.white
                      : widget.isDark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                    Color(0xFF2C5364)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFDFBFB), Color(0xFFECECEC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calculator',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: Icon(widget.isDark
                          ? Icons.light_mode
                          : Icons.dark_mode),
                      onPressed: widget.onToggleTheme,
                    )
                  ],
                ),
              ),

              /// DISPLAY
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                              widget.isDark ? 0.08 : 0.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (activeOperator.isNotEmpty)
                              Text(
                                activeOperator,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            Text(
                              display,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Row(children: [
                calcButton('C', isOperator: true),
                calcButton('÷',
                    isOperator: true,
                    isActive: activeOperator == '÷'),
                calcButton('×',
                    isOperator: true,
                    isActive: activeOperator == '×'),
                calcButton('-',
                    isOperator: true,
                    isActive: activeOperator == '-'),
              ]),
              Row(children: [
                calcButton('7'),
                calcButton('8'),
                calcButton('9'),
                calcButton('+',
                    isOperator: true,
                    isActive: activeOperator == '+'),
              ]),
              Row(children: [
                calcButton('4'),
                calcButton('5'),
                calcButton('6'),
                calcButton('=', isOperator: true),
              ]),
              Row(children: [
                calcButton('1'),
                calcButton('2'),
                calcButton('3'),
                calcButton('0'),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
