// ./lib/models/player.dart

// Import necessary packages and other files
import 'package:flutter/material.dart'; // Core Flutter widgets
import './gender.dart'; // Import the Gender enum for player gender categorization

// Player class representing a player in the game
class Player {
  String name; // Name of the player
  Gender gender; // Gender of the player (Male, Female, Other)
  Color color; // Color representing the player

  // Constructor for the Player class
  Player({
    required this.name, // Required parameter: player's name
    required this.gender, // Required parameter: player's gender
    required this.color, // Required parameter: player's color
  });
}
