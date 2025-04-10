# echokart

EchoKart - Shopping App with Audio Player
EchoKart is a feature-rich mobile application built with Flutter that combines e-commerce shopping features with an integrated audio player. The app utilizes the BLoC pattern for state management, providing a clean and maintainable architecture.

Features
Product Catalog: Browse through a variety of products with detailed information
Shopping Cart: Add products to cart, update quantities, and remove items
Audio Player: Listen to audio tracks with playback controls
User Information Form: Collect user data with validation
Responsive UI: Beautiful and intuitive interface with Material Design
Screenshots
[Insert your screenshots here]

Getting Started
Follow these instructions to get the app up and running on your local machine for development and testing purposes.

Prerequisites
Flutter SDK (version 3.0.0 or higher)
Dart SDK (version 2.17.0 or higher)
Android Studio / VS Code with Flutter plugins
An emulator or physical device for testing
Installation

Clone the repository
git clone https://github.com/naman30903/echokart.git
cd echokar 
Install dependencies
flutter pub get
Add audio files (if not already included)
Create an audio directory in your project
Add audio files to this directory (e.g., forest_birds.mp3, ocean_waves.mp3, gentle_rain.mp3)
Update pubspec.yaml to include these assets:
flutter:
  assets:
    - assets/audio/
Run the application
flutter run
Project Structure
lib/
├── bloc/               # BLoC state management
│   ├── audio_bloc.dart
│   ├── audio_event.dart
│   ├── audio_state.dart
│   └── cart_bloc.dart
├── data/
│   └── models/         # Data models
│       ├── audio_status.dart
│       ├── audio_track.dart
│       ├── cart_item.dart
│       └── product.dart
├── ui/
│   ├── screens/        # App screens
│   │   ├── audio_player.dart
│   │   ├── cart_screen.dart
│   │   ├── form_screen.dart
│   │   ├── home.dart
│   │   └── product_detail.dart
│   └── widgets/        # Reusable widgets
│       ├── audio_progress_bar.dart
│       └── empty_state.dart
└── main.dart           # Application entry point
Key Components
Audio Player
The audio player feature allows users to play, pause, and navigate through audio tracks. It includes:

Play/pause control
Next/previous track buttons
Progress bar with seek functionality
Track information display
Favorite button
Shopping Cart
The shopping cart system enables users to:

Add products to cart
Update item quantities
Remove items (with undo functionality)
View order summary with pricing
Proceed to checkout
Form Handling
The app includes a form with:

Input validation
Dynamic dropdown fields for location selection
Proper error messaging
Responsive design
Dependencies
flutter_bloc: For state management
equatable: For value equality comparisons
audioplayers: For audio playback functionality
Building for Production
To build a release version of the app:

For Android:

flutter build apk --release
For iOS:

flutter build ios --release
Contributing
Fork the Project
Create your Feature Branch (git checkout -b feature/AmazingFeature)
Commit your Changes (git commit -m 'Add some AmazingFeature')
Push to the Branch (git push origin feature/AmazingFeature)
Open a Pull Request
License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgments
Flutter for the amazing framework
Bloc Library for state management solutions
audioplayers for audio functionality
