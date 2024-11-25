import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedIconButton2 extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size; // Add a size parameter

  const AnimatedIconButton2({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0, // Default size
  });

  @override
  AnimatedIconButton2State createState() => AnimatedIconButton2State();
}

class AnimatedIconButton2State extends State<AnimatedIconButton2> {
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
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.all(8.0.w), // Use ScreenUtil for padding
        transform: Matrix4.translationValues(
          isPressed ? 3.0.w : 0.0, // Use ScreenUtil for x offset
          isPressed ? 3.0.h : 0.0, // Use ScreenUtil for y offset
          0.0,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: const Color(0xFF000000),
            width: 3.0.w, // Use ScreenUtil for border width
          ),
          borderRadius: BorderRadius.circular(0.0.w), // Use ScreenUtil for border radius
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
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: widget.size.sp, // Use ScreenUtil for icon size
        ),
      ),
    );
  }
}
