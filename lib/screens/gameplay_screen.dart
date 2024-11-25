import 'package:flutter/material.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../models/player.dart';
import '../screens/store_screen.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_button_2.dart';
import '../widgets/animated_button_3.dart';
import '../widgets/animated_icon_button.dart';
import '../widgets/animated_icon_button_2.dart';

class GameplayScreen extends StatefulWidget {
  final List<Player> players;

  const GameplayScreen({super.key, required this.players});

  @override
  GameplayScreenState createState() => GameplayScreenState();
}

class GameplayScreenState extends State<GameplayScreen>
    with SingleTickerProviderStateMixin {
  int _currentPlayerIndex = 0;
  String _currentAction = "Roll the dice to start!";
  final List<String> _actionHistory = [];
  final List<String> maleActions = [];
  final List<String> femaleActions = [];
  final List<String> otherActions = [];
  bool _isDiceVisible = false;
  bool _isHistoryVisible = false;
  bool _showHelpText = false;
  bool _isTurnComplete = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  // late Flutter3DController _diceController;

  // New variables for dice rolling and scoring
  int _diceValue = 1;
  List<int> _scores = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

// Initialize male, female, and other action lists
    maleActions.addAll([
      "Do a superhero pose!",
      "Imitate a famous male movie star.",
      "Flex your muscles like a bodybuilder.",
      "Pretend to be a football player scoring a touchdown.",
      "Imitate a famous rapper.",
      "Show off a martial arts move.",
      "Pretend to shave with an invisible razor.",
      "Do a cowboy stance and tip your hat.",
      "Pretend to lift an extremely heavy weight.",
      "Imitate a rockstar playing a guitar solo.",
      "Mimic a male voice-over from a commercial.",
      "Do a classic boxing stance and throw a punch.",
      "Imitate a famous male comedian.",
      "Pretend to be a race car driver revving an engine.",
      "Do a quick salute like a soldier.",
      "Strike a bodybuilder pose.",
      "Pretend to be a knight in a sword fight.",
      "Act like a famous male character in an action movie.",
      "Do a deep bow like a gentleman.",
      "Imitate a male model on the runway.",
      "Do a strong-man competition pose.",
      "Pretend to be a chef cooking an epic meal.",
      "Strike a pose like a male fashion model.",
      "Imitate a famous male singer on stage.",
      "Pretend to be a king giving orders."
    ]);

    femaleActions.addAll([
      "Show off your favorite dance move.",
      "Imitate a famous female movie star.",
      "Pretend to be a queen giving a speech.",
      "Pretend to do a ballet twirl.",
      "Imitate a famous pop singer on stage.",
      "Do a graceful curtsy.",
      "Strike a yoga pose.",
      "Pretend to be a famous female superhero.",
      "Do an over-the-top runway walk like a model.",
      "Imitate a famous actress accepting an award.",
      "Pretend to put on makeup quickly.",
      "Act like you're performing in a musical.",
      "Pretend to serve tea like royalty.",
      "Imitate a cheerleader doing a cheer.",
      "Pose like a fitness instructor.",
      "Pretend to be a detective solving a mystery.",
      "Imitate a famous female TV host.",
      "Do a slow-motion hair flip.",
      "Pretend to paint your nails dramatically.",
      "Strike a pose like a female action hero.",
      "Do a quick dance move like a ballerina.",
      "Pretend to do a photoshoot like a supermodel.",
      "Imitate a famous female talk show host.",
      "Pretend to be a famous female athlete.",
      "Do a pose as if you're starring in a perfume ad."
    ]);

    otherActions.addAll([
      "Do something creative!",
      "Express yourself with a unique pose.",
      "Create your own action move.",
      "Pretend to be a mime trapped in a box.",
      "Do an animal impression of your choice.",
      "Pretend you're holding an invisible object.",
      "Strike a pose like a mannequin in a store window.",
      "Imitate a famous animated character.",
      "Pretend you're floating in zero gravity.",
      "Do a slow-motion walk like in an action scene.",
      "Pretend to juggle invisible balls.",
      "Imitate a robot malfunctioning.",
      "Do a dance move from your favorite video game.",
      "Pretend you're doing a cooking show.",
      "Act out your favorite hobby in slow motion.",
      "Do a pose like you're on a rollercoaster.",
      "Pretend you're a newscaster reporting live.",
      "Imitate a famous comedian delivering a punchline.",
      "Do a funny walk like a clown.",
      "Pretend you're controlling an imaginary puppet.",
      "Do an exaggerated pose like a cartoon character.",
      "Imitate someone playing air guitar.",
      "Pretend you're swimming in an invisible pool.",
      "Do a dance like you're at a party.",
      "Strike a pose like you're a famous artist unveiling a masterpiece."
    ]);

    // Initialize scores for each player
    _scores = List.filled(widget.players.length, 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isTurnComplete) return;

    final currentPlayer = widget.players[_currentPlayerIndex];
    final String randomAction;

    _diceValue = Random().nextInt(6) + 1;

    if (currentPlayer.gender == 'Male') {
      randomAction = maleActions[
      DateTime.now().millisecondsSinceEpoch % maleActions.length];
    } else if (currentPlayer.gender == 'Female') {
      randomAction = femaleActions[
      DateTime.now().millisecondsSinceEpoch % femaleActions.length];
    } else {
      randomAction = otherActions[
      DateTime.now().millisecondsSinceEpoch % otherActions.length];
    }

    setState(() {
      _isDiceVisible = true;
      _currentAction = randomAction;
      _actionHistory.insert(
          0, "${currentPlayer.name}: $randomAction (+$_diceValue)");
    });

    _showTurnActionSheet();  // Show the bottom sheet for player actions
  }

  void _turnComplete() {
    setState(() {
      _scores[_currentPlayerIndex] += _diceValue;
      _isTurnComplete = true;
    });
    Navigator.of(context).pop(); // Close the bottom sheet
    _checkForWinner();
  }

  void _skipTurn() {
    final currentPlayer = widget.players[_currentPlayerIndex];

    setState(() {
      _actionHistory.insert(0, "${currentPlayer.name}: Skipped turn");
      _isTurnComplete = true;
    });

    Navigator.of(context).pop(); // Close the bottom sheet
    _nextTurn();
  }

  void _nextTurn() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        _currentPlayerIndex = (_currentPlayerIndex + 1) % widget.players.length;
        _currentAction = "Roll the dice!";
        _isDiceVisible = false; // Hide the dice
        _isTurnComplete = false; // Reset turn complete flag
      });
    });
  }

  void _showTurnActionSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.deepPurpleAccent,
      isScrollControlled: false,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.black.withOpacity(0.0),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedIconButton2(
                icon: Icons.skip_next,
                onPressed: _skipTurn,
              ),
              SizedBox(width: 16.sp),
              AnimatedIconButton(
                icon: Icons.check,
                onPressed: _turnComplete,
              ),
            ],
          ),
        );
      },
    );
  }

  void _checkForWinner() {
    if (_scores[_currentPlayerIndex] >= 50) {
      _showWinnerDialog();
    } else {
      _nextTurn();
    }
  }

  void _showWinnerDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(color: Colors.black, width: 3.0.w),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
                  color: Colors.red,  // Header color
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Game Over!',
                        style: TextStyle(
                          fontFamily: 'MochiyPopOne',
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 0.r,
                              color: Colors.black,
                              offset: Offset(3.w, 3.h),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.w,
                          shadows: [
                            Shadow(
                              blurRadius: 0.r,
                              color: Colors.black,
                              offset: Offset(3.w, 3.h),
                            ),
                          ],
                        ),
                        onPressed: () => Navigator.pop(context),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white, // Background color for the dialog content
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Here are the final scores:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                      ...widget.players.asMap().entries.map((entry) {
                        final playerIndex = entry.key;
                        final player = entry.value;
                        return Text(
                          '${player.name}: ${_scores[playerIndex]} points',
                          style: TextStyle(
                            fontFamily: 'Bungee',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.red,
                            shadows: [
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
                        );
                      }),
                      SizedBox(height: 16.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedButton2(
                            text: 'Main Menu',
                            onPressed: () {
                              _resetGame();
                              Navigator.pop(context);
                              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  void _resetGame() {
    Navigator.of(context).pop(); // Close the dialog
    setState(() {
      _scores = List.filled(widget.players.length, 0); // Reset scores
      _currentPlayerIndex = 0;
      _currentAction = "Roll the dice to start!";
      _isDiceVisible = false;
      _actionHistory.clear(); // Clear the action history
    });
  }

  Future<void> _showAddActionDialog() async {
    final TextEditingController actionController = TextEditingController();
    final String? newAction = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(color: Colors.black, width: 3.0.w),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0.r),
            child: CustomPaint(
              painter: TexturePatternPainter(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.black, width: 3.0.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Text(
                            'Customize Actions',
                            style: TextStyle(
                              fontFamily: 'MochiyPopOne',
                              shadows: [
                                Shadow(
                                  blurRadius: 0.r,
                                  color: Colors.black,
                                  offset: Offset(3.w, 3.h),
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24.sp,
                            shadows: [
                              Shadow(
                                blurRadius: 0.r,
                                color: Colors.black,
                                offset: Offset(3.w, 3.h),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Column(
                      children: [
                        TextField(
                          controller: actionController,
                          decoration: InputDecoration(
                            hintText: 'Enter a New Action',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0.r),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 4.0.w,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedButton2(
                              text: 'Save',
                              onPressed: () =>
                                  Navigator.pop(context, actionController.text),
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
        );
      },
    );

    if (newAction != null && newAction.isNotEmpty) {
      setState(() {
        if (widget.players[_currentPlayerIndex].gender == 'Male') {
          maleActions.add(newAction);
        } else if (widget.players[_currentPlayerIndex].gender == 'Female') {
          femaleActions.add(newAction);
        } else {
          otherActions.add(newAction);
        }
      });
    }
  }

  void _showHelp() {
    setState(() {
      _showHelpText = true;
      _animationController.forward().then((_) {
        Future.delayed(const Duration(seconds: 15), () {
          _animationController.reverse().then((_) {
            setState(() {
              _showHelpText = false;
            });
          });
        });
      });
    });
  }

  void _toggleHistoryVisibility() {
    setState(() {
      _isHistoryVisible = !_isHistoryVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPlayerName = widget.players[_currentPlayerIndex].name;
    final currentPlayerScore = _scores[_currentPlayerIndex];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: CustomPaint(
          painter: BackgroundPainter(),
          child: Stack(
            children: [
              Column(
                children: [
                  // AppBar with custom styling
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  offset: Offset(-2.0.w, -2.0.h),
                                ),
                              ],
                            ),
                            Transform.translate(
                              offset: Offset(-25.0.w, -10.0.h),
                              child: Transform.rotate(
                                angle: -1.57079633,
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
                                      offset: Offset(-2.0.w, -2.0.h),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8.0.w),
                        Text(
                          'PartyDice',
                          style: TextStyle(
                            fontFamily: 'MochiyPopOne',
                            color: Colors.amber,
                            fontSize: 30.sp,
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'It\'s $currentPlayerName\'s Turn!',
                            style: TextStyle(
                              fontFamily: 'Bungee',
                              color: Colors.greenAccent,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              shadows: [
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
                          ),
                          // Dice visibility is conditional
                          if (_isDiceVisible)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black, // Border color
                                      width: 2.w, // Border width
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 24.r,
                                    backgroundColor: Colors.greenAccent,
                                    child: Text(
                                      '+$_diceValue',
                                      style: TextStyle(
                                        fontFamily: 'Bungee',
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  'Score: $currentPlayerScore',
                                  style: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    color: Colors.amber,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
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
                                ),
                              ],
                            ),
                          SizedBox(height: 16.h),
                          Text(
                            _currentAction,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              color: Colors.amber,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              shadows: [
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
                          SizedBox(height: 16.h),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: _isHistoryVisible
                                ? 300.h
                                : 80.h, // Adjusted heights
                            padding: EdgeInsets.all(8.0.w),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8.0.r),
                              border:
                                  Border.all(color: Colors.black, width: 3.0.w),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        shadows: [
                                          Shadow(
                                            blurRadius: 0.r,
                                            color: Colors.black,
                                            offset: Offset(3.w, 3.h),
                                          ),
                                        ],
                                        _isHistoryVisible
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      onPressed: _toggleHistoryVisibility,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                    SizedBox(width: 8.0.w),
                                    Text(
                                      'Roll History',
                                      style: TextStyle(
                                        fontFamily: 'MochicyPopOne',
                                        shadows: [
                                          Shadow(
                                            blurRadius: 0.r,
                                            color: Colors.black,
                                            offset: Offset(3.w, 3.h),
                                          ),
                                        ],
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        8.0.h), // Add space below the title and icon
                                Expanded(
                                  child: _isHistoryVisible
                                      ? ListView(
                                          children: _actionHistory
                                              .map((action) => Text(
                                                    action,
                                            style: TextStyle(
                                              fontFamily: 'RobotoCondensed',
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Buttons at the bottom
                  Container(
                    padding: EdgeInsets.all(16.0.w),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedButton(
                          text: 'Help',
                          onPressed: _showHelp,
                        ),
                        SizedBox(width: 16.w),
                        AnimatedButton(
                          text: 'Roll Dice',
                          onPressed: _isDiceVisible ? null : () => _rollDice(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_showHelpText)
                Positioned(
                  bottom: 450.0.h,
                  left: 16.0.w,
                  right: 16.0.w,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(16.0.w),
                      color: Colors.transparent,
                      child: Text(
                        '1. Tap "Roll Dice" to get a random action.\n'
                        '2. Perform or skip the specified action.\n'
                        '3. Click the red "Skip Turn" button or the green "Turn Complete" button to end your turn.\n'
                        '4. Pass the device to the next player when your turn is over.',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 16.0.h,
                left: 16.0.w,
                child: AnimatedIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                            side: BorderSide(color: Colors.black, width: 3.0.w),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
                                  color: Colors.red,  // Header color
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Quit Game?',
                                        style: TextStyle(
                                          fontFamily: 'MochiyPopOne',
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 0.r,
                                              color: Colors.black,
                                              offset: Offset(3.w, 3.h),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24.w,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 0.r,
                                              color: Colors.black,
                                              offset: Offset(3.w, 3.h),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                                // Content
                                Container(
                                  color: Colors.white, // Background color for dialog content
                                  padding: EdgeInsets.all(16.0.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Are you sure you want to quit the game?',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontFamily: 'RobotoCondensed',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16.0.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          AnimatedButton3(
                                            onPressed: () {Navigator.of(context).pop();},
                                            text: 'Cancel',
                                          ),
                                          AnimatedButton2(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close dialog
                                              Navigator.pop(context); // Exit the game screen
                                              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                            },
                                            text: 'Quit',
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  size: 24.0.w,
                ),
              ),

              Positioned(
                top: 16.0.h,
                right: 16.0.w,
                child: AnimatedIconButton(
                  icon: Icons.playlist_add,
                  onPressed: () {
                    _showAddActionDialog();
                  },
                  size: 24.0.w,
                ),
              ),
              Positioned(
                top: 12.h,  // Position the lock icon inside the "Add to List" icon
                right: 12.w,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.storefront,
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
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Unlock in the PartyDice Store',
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
                        action: SnackBarAction(
                          label: 'Go to store',
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StoreScreen()),
                            );
                          },
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
                  },
                  child: Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 54.0.w,
                    shadows: [
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter class to draw the crosshatch pattern
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

class TexturePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const pattern =
        TexturePattern(bgColor: Colors.white, fgColor: Colors.blueGrey);
    pattern.paintOnCanvas(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
