import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderSelection extends StatefulWidget {
  final ValueChanged<String> onGenderSelected;

  const GenderSelection({super.key, required this.onGenderSelected});

  @override
  GenderSelectionState createState() => GenderSelectionState();
}

class GenderSelectionState extends State<GenderSelection> {
  String selectedGender = '';

  void clearSelection() {
    setState(() {
      selectedGender = '';
    });
    widget.onGenderSelected(selectedGender);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w, // Use ScreenUtil for width
      child: Column(
        children: [
          _genderButton('Other', context),
          _genderButton('Female', context),
          _genderButton('Male', context),
        ],
      ),
    );
  }

  Widget _genderButton(String gender, BuildContext context) {
    final bool isSelected = selectedGender == gender;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.greenAccent : Colors.amber,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 20.0.h), // Use ScreenUtil for vertical padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 3.0.w), // Use ScreenUtil for border width
        ),
      ),
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
        widget.onGenderSelected(gender);
      },
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          gender,
          style: TextStyle(
            fontFamily: 'Satisfy',
            color: isSelected ? Colors.black : Colors.black,
            fontSize: 20.sp, // Use ScreenUtil for font size
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0.sp, // Use ScreenUtil for letter spacing
          ),
        ),
      ),
    );
  }
}
