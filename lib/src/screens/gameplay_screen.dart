// ./lib/screens/gameplay_screen.dart

// Import necessary packages and other files
import 'package:flutter/material.dart'; // Core Flutter widgets
import 'dart:developer' as developer; // Logging utilities
import 'dart:math'; // Random number generation
import '../models/player.dart'; // Player model
import '../widgets/player_card.dart'; // Player card widget
import '../data/actions.dart'; // List of possible actions
import '../data/body_parts.dart'; // List of possible body parts
import '../models/gender.dart'; // Gender enum
import '../widgets/feedback_form.dart'; // Feedback form widget

class GameplayScreen extends StatefulWidget {
  final List<Player> players;

  const GameplayScreen({super.key, required this.players});

  static const String routeName = '/gameplay';

  @override
  GameplayScreenState createState() => GameplayScreenState();
}

// State class for the GameplayScreen
class GameplayScreenState extends State<GameplayScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random(); // Random number generator
  late final AnimationController _controller; // Animation controller

  // Value notifiers for keeping track of current and target players
  final ValueNotifier<int> currentPlayerIndex =
      ValueNotifier(0); // Current player's index
  final ValueNotifier<int> targetPlayerIndex =
      ValueNotifier(1); // Target player's index
  final ValueNotifier<double> textOpacity =
      ValueNotifier(0.0); // Opacity for transitions (initially hidden)
  final ValueNotifier<double> diceOpacity =
      ValueNotifier(0.0); // Opacity for dice (initially hidden)

  // Late-initialized variables for storing random action and body part
  late String randomAction; // Random action to be performed
  late String randomBodyPart; // Random body part to be targeted

  late bool _isRolling =
      false; // Flag to control dice roll animation visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Synchronize with the screen's refresh rate
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    _initializeFirstTurn(); // Set up the first turn
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    currentPlayerIndex.dispose(); // Dispose of the current player index
    targetPlayerIndex.dispose(); // Dispose of the target player index
    textOpacity.dispose(); // Dispose of the text opacity
    diceOpacity.dispose(); // Dispose of the dice opacity
    super.dispose(); // Call parent dispose
  }

  void _startDiceRoll() {
    _isRolling = true; // Set flag to indicate that the dice roll has started
    diceOpacity.value = 1.0; // Show the dice roll animation

    Future.delayed(const Duration(milliseconds: 6000), () {
      _isRolling = false; // Dice roll ends, set flag to false
      setState(() {
        textOpacity.value = 1.0; // Show the text instructions
      });
    });
  }

  // Function to initialize the first turn
  void _initializeFirstTurn() {
    _setRandomActionAndBodyPart(); // Set the initial random action and body part
    _controller.forward(from: 0); // Restart animation
  }

  // Function to set a random action and body part
  void _setRandomActionAndBodyPart() {
    randomAction = _getRandomAction(
        widget.players[currentPlayerIndex.value].gender); // Get a random action
    randomBodyPart = _getRandomBodyPart(widget
        .players[targetPlayerIndex.value].gender); // Get a random body part
  }

  // Function to switch to the next player's turn
  void switchPlayer() {
    if (widget.players.length < 2) {
      // Ensure there's enough players
      developer.log("Cannot switch player. Not enough players.",
          name: 'Gameplay'); // Log an error message
      return; // Exit if not enough players
    }

    currentPlayerIndex.value = (currentPlayerIndex.value + 1) %
        widget.players.length; // Move to the next player

    final availableTargets = widget.players
        .asMap()
        .keys
        .where((i) =>
            i != currentPlayerIndex.value) // Avoid selecting the same player
        .toList(); // Get list of possible targets

    targetPlayerIndex.value = availableTargets[
        _random.nextInt(availableTargets.length)]; // Randomly select a target

    _setRandomActionAndBodyPart(); // Update random action and body part

    setState(() {
      textOpacity.value = 0.0; // Hide the text instructions
    });

    _controller.forward(from: 0); // Restart the animation
  }

  // Function to get a random action based on the player's gender
  String _getRandomAction(Gender gender) {
    final allActions = [
      ...commonActions, // Include common actions
      ...(actionsByGender[gender] ?? []), // Include gender-specific actions
    ];
    return allActions[
        _random.nextInt(allActions.length)]; // Return a random action
  }

  // Function to get a random body part based on the target player's gender
  String _getRandomBodyPart(Gender gender) {
    final bodyParts = bodyPartsByGender[
        gender]!; // Get the list of body parts for the given gender
    return bodyParts[
        _random.nextInt(bodyParts.length)]; // Return a random body part
  }

  @override
  Widget build(BuildContext context) {
    // Define a slide animation for the player card transitions
    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // Start from the right
      end: Offset.zero, // Slide to the original position
    ).animate(
      CurvedAnimation(
        parent: _controller, // Use the animation controller
        curve: Curves.easeInOut, // Apply an easing curve
      ),
    );

    bool showPlayerCards = _isRolling || currentPlayerIndex.value > 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'appLogo',
              child: Image.asset('assets/icon/icon.png', height: 40),
            ),
            const SizedBox(width: 8),
            const Text('Party Dice'), // App bar title
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help), // Help icon
            onPressed: () =>
                _showInstructions(context), // Show game instructions
          ),
          IconButton(
            icon: const Icon(Icons.feedback), // Feedback icon
            onPressed: () => _showFeedbackForm(context), // Show feedback form
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 100,
                  width: 150,
                ),
                if (_isRolling)
                  Positioned(
                    child: ValueListenableBuilder<double>(
                      valueListenable: diceOpacity,
                      builder: (context, opacity, child) => AnimatedOpacity(
                        opacity: opacity,
                        duration: const Duration(milliseconds: 500),
                        child: opacity > 0
                            ? SizedBox(
                                height: 100,
                                width: 150,
                                child: Image.asset(
                                  'assets/images/dice_roll_transparent.gif',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
            ValueListenableBuilder<double>(
              valueListenable: textOpacity,
              builder: (context, opacity, child) => AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 1),
                child: Text(
                  'It\'s ${widget.players[currentPlayerIndex.value].name}\'s turn!',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // PlayerCard for current player
            if (showPlayerCards)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: ValueListenableBuilder<int>(
                  valueListenable: currentPlayerIndex,
                  builder: (context, index, child) => PlayerCard(
                    player: widget.players[index],
                    isSelected: false,
                    onTap: () {},
                    slideAnimation: slideAnimation,
                    onEdit: () {},
                    onDelete: () {},
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: targetPlayerIndex,
              builder: (context, index, child) => AnimatedOpacity(
                opacity: textOpacity.value,
                duration: const Duration(seconds: 1),
                child: Text(
                  '${widget.players[currentPlayerIndex.value].name}, $randomAction ${widget.players[index].name}\'s $randomBodyPart.',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // PlayerCard for target player
            if (showPlayerCards)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: ValueListenableBuilder<int>(
                  valueListenable: targetPlayerIndex,
                  builder: (context, index, child) => PlayerCard(
                    player: widget.players[index],
                    isSelected: false,
                    onTap: () {},
                    slideAnimation: slideAnimation,
                    onEdit: () {},
                    onDelete: () {},
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startDiceRoll();
                textOpacity.value = 0;
                Future.delayed(const Duration(milliseconds: 500), () {
                  switchPlayer();
                  textOpacity.value = 1;
                });
              },
              child: const Text('Roll Dice'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show game instructions
  void _showInstructions(BuildContext context) {
    showDialog(
      context: context, // Context for the dialog
      builder: (context) => AlertDialog(
        title: const Text("Game Instructions"), // Dialog title
        content: const Text(
          "**Turn-based Gameplay**\nEach player takes a turn. Target players are randomized.\n\n"
          "**Follow the Instructions**\nPress 'Roll Dice'. The screen will display two players and an action to perform on the other player.\n\n"
          "**Proceed to Next Turn**\nPress 'Roll Dice' to continue.\n\n"
          "**Player Selection Screen**\nUse the back arrow icon to return to the previous screen to edit players or change settings.\n\n"
          "**Provide Feedback**\nUse the feedback icon in the corner to let us know what you think. Provide a valid email address if you would like a response.\n\n"
          "**Have Fun**\nEnjoy the game and remember to keep it playful and respectful.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text("Close"), // Button label
          ),
        ],
      ),
    );
  }

  // Function to show the feedback form dialog
  void _showFeedbackForm(BuildContext context) {
    showDialog(
      context: context, // Context for the dialog
      builder: (context) => const FeedbackForm(), // Show the feedback form
    );
  }
}
