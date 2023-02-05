import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final Color? disabledColor;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final Widget? child;
  late bool isCircle;
  final double minimumWidth;
  final double minimumHeight;

  RoundedButton(
      {Key? key,
      this.text = '',
      this.fontSize = 20,
      this.color,
      this.disabledColor,
      this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      this.onPressed,
      this.isCircle = false,
      this.minimumWidth = 0,
      this.minimumHeight = 0,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize:
            MaterialStateProperty.all<Size>(Size(minimumWidth, minimumHeight)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledColor!;
          }
          return color!;
        }),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          isCircle
              ? CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(padding),
        elevation: MaterialStateProperty.all<double>(0.5),
      ),
      onPressed: onPressed,
      child: text.isNotEmpty
          ? Text(
              text,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            )
          : child,
    );
  }
}
