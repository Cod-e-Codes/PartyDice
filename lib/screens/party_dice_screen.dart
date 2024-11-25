import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_icon_button.dart';
import '../widgets/gender_selection.dart';
import '../widgets/player_card.dart';
import '../screens/gameplay_screen.dart';
import '../screens/store_screen.dart';
import '../screens/login_screen.dart';

class PartyDiceScreen extends StatefulWidget {
  const PartyDiceScreen({super.key});

  @override
  PartyDiceScreenState createState() => PartyDiceScreenState();
}

class PartyDiceScreenState extends State<PartyDiceScreen>
    with SingleTickerProviderStateMixin {
  final List<Player> players = [];
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<GenderSelectionState> _genderSelectionKey = GlobalKey();
  bool _showHelpText = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Unfocus the TextField after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode()); // Request focus on an empty node
        _nameFocusNode.unfocus(); // Unfocus the TextField explicitly
      }
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    }
  }

  void _addPlayer() {
    final name = nameController.text.trim();
    final selectedGender = _genderSelectionKey.currentState?.selectedGender;

    if (name.isEmpty) {
      // Show snackbar for missing name
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8.0.w),
              Text(
                'Please enter a player name.',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(color: Colors.black, width: 3.0.w),
          ),
          margin: EdgeInsets.all(16.0.w),
        ),
      );
      return;
    }

    if (selectedGender == null || selectedGender.isEmpty) {
      // Show snackbar for missing gender
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8.0.w),
              Text(
                'Please select a gender.',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(color: Colors.black, width: 3.0.w),
          ),
          margin: EdgeInsets.all(16.0.w),
        ),
      );
      return;
    }

    // Add player if both name and gender are provided
    setState(() {
      players.add(Player(name: name, gender: selectedGender));
      nameController.clear();
      _genderSelectionKey.currentState?.clearSelection();
      FocusScope.of(context).unfocus(); // Close the keyboard
    });
  }


  void _editPlayer(int index, String newName) {
    setState(() {
      players[index] = Player(name: newName, gender: players[index].gender);
    });
  }

  void _removePlayer(int index) {
    setState(() {
      players.removeAt(index);
    });
  }

  void _showHelp() {
    setState(() {
      _showHelpText = true;
      _animationController.forward().then((_) {
        Future.delayed(const Duration(seconds: 10), () {
          _animationController.reverse().then((_) {
            setState(() {
              _showHelpText = false;
            });
          });
        });
      });
    });
  }

  void _startGame() {
    if (players.length >= 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameplayScreen(players: players)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.red,
                size: 24.0.w,
                shadows: [
                  Shadow(
                    blurRadius: 0.0.r,
                    color: Colors.white54,
                    offset: Offset(2.0.w, 2.0.h),
                  ),
                  Shadow(
                    blurRadius: 0.0.r,
                    color: Colors.black,
                    offset: Offset(1.0.w, 1.0.h),
                  ),
                ],
              ),
              SizedBox(width: 8.0.w), // Space between icon and text
              Expanded(
                child: Text(
                  'Please add at least 2 players.',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(
              color: Colors.black,
              width: 3.0.w,
            ),
          ),
          margin: EdgeInsets.all(16.0.w),
        ),
      );
    }
  }
  @override
  void dispose() {
    _animationController.dispose();
    _nameFocusNode.dispose(); // Don't forget to dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Close the keyboard when tapping outside of the input field
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurpleAccent,
        body: SafeArea(
          // Add SafeArea here
          child: CustomPaint(
            painter: BackgroundPainter(), // Add custom pattern painter
            child: Column(
              children: [
                // Title
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the title and icons
                    children: [
                      SizedBox(width: 24.0.w),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.casino,
                            color: Colors.greenAccent,
                            size: 36.0.w,
                            shadows: [
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(2.0.w, 2.0.h),
                              ),
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(2.0.w, 2.0.h),
                              ),
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(-2.0.w, -2.0.h),
                              ),
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(-2.0.w, -2.0.h),
                              ),
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(-2.0.w, 2.0.h),
                              ),
                              Shadow(
                                blurRadius: 0.0.r,
                                color: Colors.black,
                                offset: Offset(2.0.w, -2.0.h),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: Offset(-25.0.w,
                                -10.0.h),
                            child: Transform.rotate(
                              angle: -1.57079633, // 45 degrees in radians
                              child: Icon(
                                Icons.celebration_outlined,
                                color: Colors.amber,
                                size: 36.0.w,
                                shadows: [
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(2.0.w, 2.0.h),
                                  ),
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(2.0.w, 2.0.h),
                                  ),
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(-2.0.w, -2.0.h),
                                  ),
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(-2.0.w, -2.0.h),
                                  ),
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(-2.0.w, 2.0.h),
                                  ),
                                  Shadow(
                                    blurRadius: 0.0.r,
                                    color: Colors.black,
                                    offset: Offset(2.0.w, -2.0.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8.0.w), // Space between icon and text
                      Text(
                        'PartyDice',
                        style: TextStyle(
                          fontFamily: 'MochiyPopOne',
                          color: Colors.amber,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 0.0.r,
                              color: Colors.red.shade900,
                              offset: Offset(4.0.w, 4.0.h),
                            ),
                            Shadow(
                              blurRadius: 0.0.r,
                              color: Colors.black,
                              offset: Offset(2.0.w, 2.0.h),
                            ),
                            Shadow(
                              blurRadius: 0.0.r,
                              color: Colors.black,
                              offset: Offset(-2.w, -2.h),
                            ),
                            Shadow(
                              blurRadius: 0.0.r,
                              color: Colors.black,
                              offset: Offset(-2.w, 2.h),
                            ),
                            Shadow(
                              blurRadius: 0.0.r,
                              color: Colors.black,
                              offset: Offset(2.w, -2.h),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      AnimatedIconButton(icon: Icons.logout, onPressed: logout),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenderSelection(
                        key: _genderSelectionKey,
                        onGenderSelected: (gender) {
                          setState(() {
                            // Do nothing here, as we will handle gender selection clearing in _addPlayer
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                focusNode: _nameFocusNode,
                                autofocus: false,
                                textCapitalization: TextCapitalization.words,
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: '✨ Enter Name... ✨',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Satisfy',
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0.w,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Satisfy',
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0.w,
                                ),
                              ),

                              SizedBox(height: 10.h),
                              // Help Text Container
                              AnimatedBuilder(
                                animation: _fadeAnimation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _showHelpText
                                        ? _fadeAnimation.value
                                        : 0.0,
                                    child: child,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_back,
                                            color: Colors.white, size: 20.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '1. Select gender',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_upward,
                                            color: Colors.white, size: 20.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '2. Enter name',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_forward,
                                            color: Colors.white, size: 20.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '3. Add player',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.white, size: 20.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'At least 2 players required',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: AnimatedIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            _addPlayer();
                            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                          },

                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return PlayerCard(
                        player: player,
                        onEdit: (newName) => _editPlayer(index, newName),
                        onRemove: () => _removePlayer(index),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0.h),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedButton(
                        text: 'Help',
                        onPressed: _showHelp,
                      ),
                      AnimatedIconButton(
                        icon: Icons.storefront,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StoreScreen()),
                          );
                        },
                        size: 24.0.w,
                      ),
                      AnimatedButton(
                        text: 'Start Game',
                        onPressed: _startGame,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CustomPainter class to draw the background pattern
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      150.0,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      200.0,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}