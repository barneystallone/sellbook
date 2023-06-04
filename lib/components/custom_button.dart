import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  const CustomButton(
      {super.key,
      required this.title,
      this.onPressed,
      this.width = 300,
      this.shape,
      this.padding = const EdgeInsets.symmetric(vertical: 46, horizontal: 20),
      this.backgroundColor = const Color.fromARGB(221, 26, 25, 25),
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding,
        child: SizedBox(
          width: width,
          height: 60,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: shape, backgroundColor: backgroundColor),
            child: Text(title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                )),
          ),
        ),
      ),
    );
  }
}
