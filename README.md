# ProWork

**ProWork** - A sleek team project progress tracker and member contribution accelerator built with Flutter and Firebase.

## 🎯 Features

- **Dual-Role Authentication**: Admin lead and team member access with personalized dashboards
- **Real-Time Sync**: Firebase Firestore integration for instant data synchronization across all devices
- **Goal Tracking**: Create, manage, and track project goals with checklist items
- **Accomplishments**: Log and celebrate team achievements and milestones
- **Member Profiles**: Comprehensive member profiles with contribution tracking
- **Contribution Heatmap**: Visual representation of team member activity and contributions
- **Password Management**: Secure authentication with custom password support per user
- **Modern UI**: Sleek dark theme with smooth animations and glass morphism effects

## 📱 Platforms

- ✅ Android
- ✅ iOS (via Flutter)
- ✅ Web (via Flutter)

## 🚀 Getting Started

### Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Android SDK (for Android development)
- Firebase project with Firestore enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/axiom-afk/Prowork.git
   cd Prowork
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add Firebase Configuration**
   - Download `google-services.json` from your Firebase project
   - Place it in `android/app/`
   - For iOS, add `GoogleService-Info.plist` to `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── models/                   # Data models
│   ├── goal.dart
│   ├── accomplishment.dart
│   ├── member.dart
│   ├── contribution.dart
│   └── project_data.dart
├── providers/
│   └── app_state.dart       # State management with Firebase sync
├── services/
│   └── firebase_service.dart # Firebase Firestore operations
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── member_profile_screen.dart
│   ├── admin_settings_screen.dart
│   └── ...
├── widgets/                  # Reusable widgets
│   ├── sleek_button.dart
│   ├── contribution_graph.dart
│   ├── goal_card.dart
│   └── ...
└── theme/
    └── app_theme.dart       # Dark theme configuration
```

## 🔐 Authentication

### Default Credentials
- **Admin Password**: `ro696969ho`
- **Member Password**: `user2026`

### Password Management
- Members can change their password after login via Profile → Edit → Change Passcode
- Each member maintains their own individual password
- Admin can manage project-wide settings

## 🔥 Firebase Integration

### Firestore Collections
- `project/settings` - Project-wide configuration
- `goals` - Project goals and checklists
- `accomplishments` - Team accomplishments and milestones
- `members` - Team member profiles and data
- `contributions` - Member activity tracking (nested in members)

### Real-Time Features
- Admin updates instantly appear on all member devices
- Member contributions sync in real-time
- Goal progress updates automatically across all connected clients

## 🎨 Design Features

- **Modern Dark UI**: Sleek dark theme with green accents
- **Glass Morphism**: Frosted glass effects for depth
- **Smooth Animations**: Polished transitions and interactions
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Custom Widgets**: Purpose-built components for better UX

## 📊 Key Screens

| Screen | Purpose |
|--------|---------|
| Login | Role-based authentication (Admin/Member) |
| Home | Dashboard with goals and accomplishments |
| Member Profile | Personal and team member profiles |
| Goal Editor | Create and manage project goals |
| Accomplishment Tracker | Log team achievements |
| Admin Settings | Project configuration and management |

## 🔧 Technologies

- **Framework**: Flutter 3.10+
- **State Management**: ChangeNotifier
- **Backend**: Firebase Firestore
- **UI**: Material Design 3
- **Fonts**: Google Fonts
- **Localization**: Intl package

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.8.1
  cloud_firestore: ^5.6.2
  shared_preferences: ^2.2.3
  google_fonts: ^6.2.1
  intl: ^0.19.0
```

## 🔒 Security Notes

⚠️ **Important**: 
- Never commit `google-services.json` or `GoogleService-Info.plist`
- Update Firebase Security Rules before production deployment
- Change default admin password immediately
- Enable proper Firestore rules for data isolation

## 📝 Development

### Running Tests
```bash
flutter test
```

### Build APK
```bash
flutter build apk
```

### Build iOS
```bash
flutter build ios
```

### Build Web
```bash
flutter build web
```

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is open source and available under the MIT License.

## 👨💻 Author

**axiom-afk** - [GitHub Profile](https://github.com/axiom-afk)

---

## 🚀 Deploy to Production

Before deploying:
1. Update Firebase Security Rules
2. Change all default passwords
3. Enable proper authentication
4. Test on multiple devices
5. Review Firebase quotas and costs

## 📞 Support

For issues or questions, please create an issue on GitHub: [Issues](https://github.com/axiom-afk/Prowork/issues)

---

**ProWork** - Build amazing projects, track amazing teams. 🚀
