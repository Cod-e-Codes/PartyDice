// ./lib/data/body_parts.dart

// Import necessary packages and other files
import '../models/gender.dart'; // Gender categorization

// List of common body parts shared across all genders
final List<String> commonBodyParts = [
  'face',
  'cheeks',
  'mouth',
];

// Map to define specific body parts based on gender
final Map<Gender, List<String>> bodyPartsByGender = {
  // Additional body parts for male gender, extending common parts
  Gender.male: [
    ...commonBodyParts, // Include common body parts
    'muscles',
    'arms',
    'shoulders',
  ],
  // Additional body parts for female gender, extending common parts
  Gender.female: [
    ...commonBodyParts, // Include common body parts
    'chest',
    'thighs',
    'waist',
  ],
  // Additional body parts for other genders, extending common parts
  Gender.other: [
    ...commonBodyParts, // Include common body parts
    'tail',
    'belly',
    'ears',
  ],
};
