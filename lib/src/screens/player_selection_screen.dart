import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:random_x/random_x.dart';
import '../models/player.dart';
import '../models/gender.dart';
import '../widgets/player_card.dart';
import 'gameplay_screen.dart';
import '../settings/settings_view.dart';
import '../settings/settings_controller.dart';

class PlayerSelectionScreen extends StatefulWidget {
  final SettingsController settingsController;

  const PlayerSelectionScreen({
    super.key,
    required this.settingsController,
  });

  static const String routeName = '/player_selection';

  @override
  PlayerSelectionScreenState createState() => PlayerSelectionScreenState();
}

class PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  final List<Player> players = [];
  final TextEditingController _playerNameController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _selectedPlayerIndex = -1;
  Gender _selectedGender = Gender.male;
  final Set<Color> usedColors = {};

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  void addPlayer() {
    final name = _playerNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player name cannot be empty')),
      );
      return;
    }

    if (players.any((p) => p.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player name must be unique')),
      );
      return;
    }

    final uniqueColor = generateUniqueColor();
    final newPlayer = Player(
      name: name,
      gender: _selectedGender,
      color: uniqueColor,
    );

    setState(() {
      players.add(newPlayer);
      usedColors.add(uniqueColor);
      _listKey.currentState?.insertItem(players.length - 1);
    });

    _playerNameController.clear();
  }

  void removePlayer() {
    if (_selectedPlayerIndex >= 0 && _selectedPlayerIndex < players.length) {
      final removedPlayer = players[_selectedPlayerIndex];
      usedColors.remove(removedPlayer.color);

      _listKey.currentState?.removeItem(
        _selectedPlayerIndex,
        (context, animation) {
          final slideAnimation = animation.drive(
            Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          );

          return PlayerCard(
            key: Key(removedPlayer.name),
            player: removedPlayer,
            isSelected: false,
            onTap: () {},
            slideAnimation: slideAnimation,
            onEdit: editPlayer,
            onDelete: removePlayer,
          );
        },
        duration: const Duration(milliseconds: 500),
      );

      setState(() {
        players.removeAt(_selectedPlayerIndex);
        _selectedPlayerIndex = -1;
      });
    }
  }

  void editPlayer() {
    if (_selectedPlayerIndex < 0 || _selectedPlayerIndex >= players.length) {
      return;
    }

    final player = players[_selectedPlayerIndex];
    _playerNameController.text = player.name;

    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = player.color;
        Gender newGender = player.gender;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Edit Player'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _playerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Player Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<Gender>(
                  value: newGender,
                  onChanged: (Gender? updatedGender) {
                    if (updatedGender != null) {
                      setState(() => newGender = updatedGender);
                    }
                  },
                  items: Gender.values.map((Gender gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(
                        gender == Gender.male
                            ? 'Male'
                            : gender == Gender.female
                                ? 'Female'
                                : 'Other',
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text('Pick a new color:'),
                ColorPicker(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  padding: const EdgeInsets.all(0),
                  columnSpacing: 0,
                  enableShadesSelection: false,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: false,
                    ColorPickerType.wheel: false,
                  },
                  color: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() => selectedColor = color);
                  },
                  width: 35,
                  height: 35,
                  borderRadius: 40,
                  spacing: 5,
                  runSpacing: 5,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final newName = _playerNameController.text.trim();

                  if (newName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Player name cannot be empty"),
                      ),
                    );
                    return;
                  }

                  if (players.any((p) => p.name == newName && p != player)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Player name must be unique"),
                      ),
                    );
                    return;
                  }

                  if (usedColors.contains(selectedColor) &&
                      selectedColor != player.color) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "This color is already used by another player.",
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    players[_selectedPlayerIndex].name = newName;
                    players[_selectedPlayerIndex].gender = newGender;
                    players[_selectedPlayerIndex].color = selectedColor;
                  });

                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {
        _selectedPlayerIndex = -1;
      });
    });
  }

  void startGame() {
    if (players.length >= 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameplayScreen(players: players),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "At least two players are required to start the game.",
          ),
        ),
      );
    }
  }

  Color generateUniqueColor() {
    Color newColor;
    const int maxTries = 50;
    int tries = 0;

    do {
      newColor = RndX.randomAccentColor;
      tries++;
    } while (usedColors.contains(newColor) && tries < maxTries);

    return newColor;
  }

  void showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Instructions"),
        content: const Text(
          "**Add Player**\nEnter a name, choose a gender, and use the 'Add Player' button. Names and colors can only be used once.\n\n"
          "**Edit Player**\nSelect a player card and use the edit icon to modify player details.\n\n"
          "**Remove Player**\nSelect a player card and use the trash icon to remove the player.\n\n"
          "**Settings**\nUse the settings icon in the corner to access the settings menu.\n\n"
          "**Start Game**\nPress 'Start Game' to begin. At least two players are required to proceed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'appLogo',
              child: Image.asset('assets/icon/icon.png', height: 40),
            ),
            const SizedBox(
                width: 8), // Add spacing between the icon and the title
            const Text(
              'Party Dice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => showInstructions(context),
          ),
          IconButton(
            icon: const Hero(
              tag: 'settingsIcon',
              child: Icon(Icons.settings),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsView(controller: widget.settingsController),
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _selectedPlayerIndex = -1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Player Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<Gender>(
                value: _selectedGender,
                onChanged: (Gender? newGender) {
                  if (newGender != null) {
                    setState(() => _selectedGender = newGender);
                  }
                },
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(
                      gender == Gender.male
                          ? 'Male'
                          : gender == Gender.female
                              ? 'Female'
                              : 'Other',
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: addPlayer,
                    child: const Text('Add Player'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: players.length >= 2 ? startGame : null,
                    child: const Text('Start Game'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: players.length,
                  itemBuilder: (context, index, animation) {
                    final player = players[index];
                    final slideAnimation = animation.drive(
                      Tween(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeInOut)),
                    );

                    return PlayerCard(
                      key: Key(player.name),
                      player: player,
                      isSelected: index == _selectedPlayerIndex,
                      onTap: () => setState(() => _selectedPlayerIndex = index),
                      slideAnimation: slideAnimation,
                      onEdit: editPlayer,
                      onDelete: removePlayer,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
