/*
 * Copyright 2024 Cody Marsengill
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
