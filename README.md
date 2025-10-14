# Hanglow

Your personalized beauty companion - Track beauty product spending, get skin care recommendations, and manage your wellness routine.

## Features

- **Budget Tracking**: Monitor your beauty product spending with monthly budgets
- **Product Discovery**: Browse curated beauty products from Sephora API
- **Skin Assessment**: Take personalized skin quizzes for product recommendations
- **Wellness Tracking**: Log daily water intake and sleep for skin health
- **Firebase Integration**: Secure user authentication and data storage

## Tech Stack

- **Flutter** with Dart 3.5.4+
- **State Management**: Riverpod
- **Database**: Firebase Firestore
- **Authentication**: Google Sign-In
- **API**: Sephora Products API
- **Design**: Material 3 with custom brown/cream theme

## Getting Started

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Set up Firebase (google-services.json and GoogleService-Info.plist included)
4. Add your API keys to `.env` file
5. Run: `flutter run`

## Environment Setup

Create a `.env` file in the project root:
```
SEPHORA_API_KEY=your_api_key_here
SEPHORA_API_HOST=sephora.p.rapidapi.com
```

## Project Structure

```
lib/
├── models/         # Data models and JSON serialization
├── providers/      # Riverpod state management
├── services/       # API services and business logic
├── screens/        # UI screens and navigation
├── widgets/        # Reusable UI components
├── themes/         # App theming and colors
└── utils/          # Utility functions and helpers
```
