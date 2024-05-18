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
