import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedButton3 extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const AnimatedButton3({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  AnimatedButton3State createState() => AnimatedButton3State();
}

class AnimatedButton3State extends State<AnimatedButton3> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          vertical: 8.0.h, // Use ScreenUtil for vertical padding
          horizontal: 24.0.w, // Use ScreenUtil for horizontal padding
        ),
        transform: Matrix4.translationValues(
          isPressed ? 3.0.w : 0.0, // Use ScreenUtil for x offset
          isPressed ? 3.0.h : 0.0, // Use ScreenUtil for y offset
          0.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(
            color: const Color(0xFF000000), // Black border
            width: 3.0.w, // Use ScreenUtil for border width
          ),
          borderRadius: BorderRadius.circular(8.0.w), // Use ScreenUtil for border radius
          boxShadow: isPressed
              ? []
              : [
            for (int i = 1; i <= 5; i++)
              BoxShadow(
                color: const Color(0xFF000000),
                offset: Offset(i.toDouble().w, i.toDouble().h), // Use ScreenUtil for offset
                blurRadius: 0.0,
              ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'RampartOne', // Use the locally defined font family
              color: Colors.black,
              fontSize: 24.sp, // Use ScreenUtil for font size
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0.sp, // Use ScreenUtil for letter spacing
            ),
          ),
        ),
      ),
    );
  }
}
