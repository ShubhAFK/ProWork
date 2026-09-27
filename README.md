# ProWork

<img width="806" height="1600" alt="Prowork" src="https://github.com/user-attachments/assets/03abfdb6-a23a-414e-b243-79f0904ef6e9" />


This is a Flutter project with Firebase real-time sync.

## Getting Started

First, install dependencies:

```bash
flutter pub get
```

Then run the development server:

```bash
flutter run
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Firestore Database
3. Download `google-services.json` to `android/app/`
4. For iOS, download `GoogleService-Info.plist` to `ios/Runner/`

## Features

- Real-time data sync with Firebase Firestore
- Dual-role authentication (Admin/Member)
- Goal tracking with checklists
- Accomplishments logging
- Member profiles with contribution tracking
- Modern dark UI with animations

## Learn More

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)

## Deploy

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```
