// ./lib/data/actions.dart

// Import necessary packages and other files
import '../models/gender.dart'; // Import the Gender enum

// Common actions that apply to all genders
final List<String> commonActions = [
  'kiss',
  'hug',
  'massage',
];

// Map to define specific actions based on gender
final Map<Gender, List<String>> actionsByGender = {
  // Actions for male gender, including common actions
  Gender.male: [
    ...commonActions, // Include common actions
    'high-five',
    'fist-bump',
    'push',
    'touch',
  ],
  // Actions for female gender, including common actions
  Gender.female: [
    ...commonActions, // Include common actions
    'twirl',
    'grind on',
    'tickle',
    'rub',
  ],
  // Actions for other genders, including common actions
  Gender.other: [
    ...commonActions, // Include common actions
    'nuzzle',
    'wave',
  ],
};
