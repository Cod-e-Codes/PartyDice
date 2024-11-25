import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import '../models/player.dart';
import '../widgets/animated_button_2.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function(String) onEdit;
  final VoidCallback onRemove;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
      // Use ScreenUtil for margins
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,
            width: 3.0.w), // Use ScreenUtil for border width
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,
                  width: 1.0.w),
              color: Colors.amber,// Use ScreenUtil for border width
            ),
            width: 100.0.w, // Use ScreenUtil for width
            height: 100.0.h, // Use ScreenUtil for height
            child: Align(
              alignment: Alignment.centerLeft,
              child: RotatedBox(
                quarterTurns: 1,
                child: Text(
                  player.gender,
                  style: TextStyle(
                    fontFamily: 'BlackOpsOne',
                    color: Colors.black,
                    fontSize: 24.0.sp,
                    // Use ScreenUtil for font size
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.0.sp, // Use ScreenUtil for letter spacing
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 100.0.h, // Use ScreenUtil for height
    decoration: BoxDecoration(
    border: Border.all(color: Colors.black,
    width: 1.0.w),
    color: Colors.deepPurple,// Use ScreenUtil for border width
    ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8.0.h, // Use ScreenUtil for top position
                    left: 8.0.w, // Use ScreenUtil for left position
                    child: Text(
                      player.name,
                      style: TextStyle(
                        fontFamily: 'MochiyPopOne',
                        color: Colors.greenAccent,
                        fontSize: 24.0.sp,
                        // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 0,
                            color: Colors.amber,
                            offset: Offset(3.0.w,
                                3.0.h), // Use ScreenUtil for shadow offset
                          ),
                          Shadow(
                            blurRadius: 0.0,
                            color: Colors.black,
                            offset: Offset(2.0.w,
                                2.0.h), // Use ScreenUtil for shadow offset
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0.h, // Use ScreenUtil for top position
                    right: 8.0.w, // Use ScreenUtil for right position
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontFamily: 'Satisfy',
                            color: Colors.greenAccent,
                            fontSize: 18.0.sp,
                            // Use ScreenUtil for font size
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                color: Colors.amber,
                                offset: Offset(3.0.w,
                                    3.0.h), // Use ScreenUtil for shadow offset
                              ),
                              Shadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(2.0.w,
                                    2.0.h), // Use ScreenUtil for shadow offset
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.0.w), // Use ScreenUtil for spacing
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                            size: 20.0.sp, // Use ScreenUtil for icon size
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                color: Colors.amber,
                                offset: Offset(3.0.w,
                                    3.0.h), // Use ScreenUtil for shadow offset
                              ),
                              Shadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(2.0.w,
                                    2.0.h), // Use ScreenUtil for shadow offset
                              ),
                            ],
                          ),
                          onPressed: () async {
                            final newName = await _showEditDialog(
                                context, player.name);
                            if (newName != null) {
                              onEdit(newName);
                            }
                          },
                          iconSize: 24.0.sp,
                          // Use ScreenUtil for icon size
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24.0.w,
                              24.0.h)), // Use ScreenUtil for button size
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8.0.h, // Use ScreenUtil for bottom position
                    right: 8.0.w, // Use ScreenUtil for right position
                    child: Row(
                      children: [
                        Text(
                          'Remove',
                          style: TextStyle(
                            fontFamily: 'Satisfy',
                            color: Colors.greenAccent,
                            fontSize: 18.0.sp,
                            // Use ScreenUtil for font size
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                color: Colors.amber,
                                offset: Offset(3.0.w,
                                    3.0.h), // Use ScreenUtil for shadow offset
                              ),
                              Shadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(2.0.w,
                                    2.0.h), // Use ScreenUtil for shadow offset
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.0.w), // Use ScreenUtil for spacing
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.greenAccent,
                            size: 20.0.sp, // Use ScreenUtil for icon size
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                color: Colors.amber,
                                offset: Offset(3.0.w,
                                    3.0.h), // Use ScreenUtil for shadow offset
                              ),
                              Shadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(2.0.w,
                                    2.0.h), // Use ScreenUtil for shadow offset
                              ),
                            ],
                          ),
                          onPressed: onRemove,
                          iconSize: 24.0.sp,
                          // Use ScreenUtil for icon size
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24.0.w,
                              24.0.h)), // Use ScreenUtil for button size
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<String?> _showEditDialog(BuildContext context,
      String currentName) async {
    final TextEditingController editController = TextEditingController(
        text: currentName);
    String? errorMessage; // Variable to hold error message

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.w),
                // Use ScreenUtil for border radius
                side: BorderSide(color: Colors.black,
                    width: 3.0.w), // Use ScreenUtil for border width
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0.w),
                // Use ScreenUtil for border radius
                child: CustomPaint(
                  painter: TexturePatternPainter(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        // Use ScreenUtil for padding
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.black,
                              width: 3.0.w), // Use ScreenUtil for border width
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              // Use ScreenUtil for padding
                              child: Text(
                                'Edit Player Name',
                                style: TextStyle(
                                  fontFamily: 'MochiyPopOne',
                                  shadows: [
                                    Shadow(
                                      blurRadius: 0,
                                      color: Colors.black,
                                      offset: Offset(3.0.w, 3.0
                                          .h), // Use ScreenUtil for shadow offset
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 20.0.sp,
                                  // Use ScreenUtil for font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24.0.sp, // Use ScreenUtil for icon size
                              ),
                              onPressed: () {
                                Navigator.pop(context,
                                    null); // Close dialog without saving
                                WidgetsBinding.instance.focusManager
                                    .primaryFocus?.unfocus();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0.w),
                        // Use ScreenUtil for padding
                        child: Column(
                          children: [
                            TextField(
                              textCapitalization: TextCapitalization.words,
                              controller: editController,
                              decoration: InputDecoration(
                                hintText: 'Enter new name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0.sp,
                                  // Use ScreenUtil for font size
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0.r),
                                  // Use ScreenUtil for border radius
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 4.0.w, // Use ScreenUtil for border width
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                // Use ScreenUtil for font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'MochiyPopOne',
                              ),
                            ),
                            if (errorMessage != null) ...[
                              SizedBox(height: 8.0.h),
                              Container(
                                color: Colors.white, // Set the background color to white
                                padding: EdgeInsets.all(4.0.w), // Add some padding around the text
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0.sp, // Use ScreenUtil for font size
                                    backgroundColor: Colors.white, // Optional, but redundant as Container already sets the background
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 16.0.h),
                            // Use ScreenUtil for spacing
                            AnimatedButton2(
                              text: 'Save',
                              onPressed: () {
                                if (editController.text
                                    .trim()
                                    .isEmpty) {
                                  setState(() {
                                    errorMessage =
                                    'Name cannot be empty'; // Update error message
                                  });
                                } else {
                                  Navigator.pop(context, editController.text);
                                  WidgetsBinding.instance.focusManager
                                      .primaryFocus?.unfocus();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

  class TexturePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const pattern = TexturePattern(bgColor: Colors.white, fgColor: Colors.blueGrey);
    pattern.paintOnCanvas(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
