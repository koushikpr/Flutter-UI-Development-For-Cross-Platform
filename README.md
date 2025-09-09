# Bagrz - Flutter UI/Animation Heavy Mobile App

A production-ready Flutter application designed for iOS and Android with a focus on beautiful UI components and smooth animations.

## 🚀 Features

- **Modern UI Design** - Beautiful, responsive interface with Material Design 3
- **Smooth Animations** - 60fps animations using Flutter Animate and custom transitions
- **Cross-Platform** - Single codebase for iOS and Android
- **Production Ready** - Proper architecture, state management, and error handling
- **Responsive Design** - Adapts to different screen sizes using ScreenUtil
- **Theme System** - Light and dark theme support with custom design tokens

## 📱 Screenshots

*Add your app screenshots here once you have your Figma designs implemented*

## 🛠 Tech Stack

### Core Framework
- **Flutter 3.35.3** - UI framework
- **Dart 3.9.2** - Programming language

### UI & Animation Libraries
- **flutter_animate** - Declarative animations
- **lottie** - Lottie animations support
- **rive** - Interactive animations
- **flutter_screenutil** - Responsive design
- **google_fonts** - Custom fonts
- **flutter_svg** - SVG support

### State Management
- **flutter_bloc** - Business logic component pattern
- **equatable** - Value equality

### Navigation
- **go_router** - Declarative routing

### Utilities
- **dio** - HTTP client
- **shared_preferences** - Local storage
- **cached_network_image** - Image caching
- **shimmer** - Loading animations

## 🏗 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart          # Theme configuration
│   └── utils/                      # Utility functions
├── features/
│   └── home/
│       └── home_screen.dart        # Home screen implementation
├── shared/
│   ├── animations/
│   │   └── page_transitions.dart   # Custom page transitions
│   └── widgets/
│       └── animated_button.dart    # Reusable animated components
└── main.dart                       # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: `#6366F1` (Indigo)
- **Secondary**: `#8B5CF6` (Purple)
- **Accent**: `#06B6D4` (Cyan)
- **Success**: `#10B981` (Emerald)
- **Warning**: `#F59E0B` (Amber)
- **Error**: `#EF4444` (Red)

### Typography
- **Font Family**: Inter (via Google Fonts)
- **Responsive sizing** using ScreenUtil

### Spacing System
- **XS**: 4px
- **S**: 8px
- **M**: 16px
- **L**: 24px
- **XL**: 32px
- **XXL**: 48px

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.3 or higher
- Dart 3.9.2 or higher
- Android Studio / VS Code
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd bagrz_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Compile SDK: 34

#### iOS
- Minimum iOS version: 12.0
- Xcode 14.0 or higher required

## 🎯 Development Guidelines

### Adding New Features
1. Create feature folder in `lib/features/`
2. Follow the established architecture pattern
3. Use BLoC for state management
4. Add animations using flutter_animate
5. Ensure responsive design with ScreenUtil

### Animation Guidelines
- Use `flutter_animate` for simple animations
- Use `Lottie` for complex After Effects animations
- Use `Rive` for interactive animations
- Maintain 60fps performance
- Follow Material Design motion principles

### Theme Usage
```dart
// Access theme colors
Theme.of(context).primaryColor
Theme.of(context).colorScheme.secondary

// Use predefined constants
AppConstants.spacingM
AppConstants.radiusL
```

## 📦 Build & Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📋 TODO

- [ ] Implement navigation between screens
- [ ] Add user authentication
- [ ] Integrate with backend APIs
- [ ] Add unit and widget tests
- [ ] Implement offline support
- [ ] Add push notifications
- [ ] Optimize for different screen sizes
- [ ] Add accessibility features

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Community packages that make development easier

---

**Ready to integrate your Figma designs!** 🎨

Once you share your Figma designs, we can:
1. Extract design tokens and colors
2. Implement pixel-perfect UI components
3. Add custom animations and micro-interactions
4. Optimize for both iOS and Android platforms