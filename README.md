# Expense Logger - Flutter App

A comprehensive expense tracking mobile application built with Flutter, featuring a modern UI design and complete user flow from onboarding to transaction management.

## Features

### 🚀 Onboarding & Authentication
- **Splash Screen**: Clean loading screen with app branding
- **Onboarding**: Welcome screen with call-to-action
- **Login/Signup**: Complete authentication flow with form validation
- **Forgot Password**: Password reset functionality

### 📊 Main Dashboard
- **Bottom Navigation**: Easy access to Home, Statistics, and Profile
- **Floating Action Button**: Quick access to add expenses/income

### 🏠 Home Screen
- **Balance Overview**: Total balance, income, and expenses summary
- **Transaction History**: Recent transactions with detailed information
- **Interactive Cards**: Tap transactions to view detailed information

### 📈 Statistics Screen
- **Interactive Charts**: Financial trends visualization using fl_chart
- **Time Period Selection**: Day, Week, Month, Year views
- **Top Spending**: Categorized spending analysis
- **Expense/Income Filter**: Toggle between different transaction types

### ➕ Add Expense/Income Screen
- **Transaction Types**: Switch between Income and Expense
- **Category Selection**: Dropdown with predefined categories
- **Amount Input**: Custom numeric keypad for easy input
- **Date Picker**: Select transaction date
- **Notes**: Additional transaction details
- **Form Validation**: Complete input validation

### 👤 Profile Management
- **User Profile**: Display user information and avatar
- **Edit Profile**: Update personal information
- **Change Password**: Secure password update
- **Account Settings**: Help, support, and account management
- **Delete Account**: Account deletion with confirmation

### 📋 Transaction Details
- **Detailed View**: Complete transaction information
- **Receipt Download**: Download transaction receipts
- **Income/Expense Details**: Different views for different transaction types

## Technical Features

### 🎨 UI/UX Design
- **Modern Design**: Clean, professional interface
- **Consistent Theming**: Blue color scheme throughout
- **Responsive Layout**: Optimized for mobile devices
- **Smooth Animations**: Fluid transitions between screens
- **Custom Components**: Reusable UI components

### 🛠️ Technical Implementation
- **Flutter Framework**: Cross-platform mobile development
- **Material Design**: Google's design language
- **Google Fonts**: Inter font family for typography
- **State Management**: Local state management with StatefulWidget
- **Navigation**: Named routes and page transitions
- **Form Validation**: Comprehensive input validation
- **Date Handling**: International date formatting

### 📦 Dependencies
- `google_fonts: ^6.1.0` - Custom typography
- `fl_chart: ^0.66.0` - Interactive charts
- `intl: ^0.19.0` - Internationalization and date formatting
- `shared_preferences: ^2.2.2` - Local data persistence

## Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
└── screens/
    ├── splash_screen.dart           # Loading screen
    ├── onboarding_screen.dart       # Welcome screen
    ├── login_screen.dart            # User authentication
    ├── signup_screen.dart           # User registration
    ├── forgot_password_screen.dart  # Password reset
    ├── main_dashboard.dart          # Main app with bottom navigation
    ├── home_screen.dart             # Dashboard with balance and transactions
    ├── statistics_screen.dart       # Charts and analytics
    ├── add_expense_screen.dart      # Add income/expense
    ├── profile_screen.dart          # User profile management
    ├── edit_profile_screen.dart     # Edit user information
    ├── change_password_screen.dart  # Password change
    ├── delete_account_screen.dart   # Account deletion
    └── transaction_details_screen.dart # Transaction details view
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_application_1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## App Flow

1. **Splash Screen** → **Onboarding** → **Login/Signup**
2. **Main Dashboard** with bottom navigation
3. **Home Screen** with balance overview and transactions
4. **Statistics Screen** with charts and analytics
5. **Add Expense/Income** with form and keypad
6. **Profile Management** with settings and account options
7. **Transaction Details** for detailed transaction information

## Customization

### Colors
The app uses a consistent blue color scheme:
- Primary: `#2196F3` (Material Blue)
- Success: `#4CAF50` (Green)
- Error: `#F44336` (Red)
- Background: `#F8F9FA` (Light Gray)

### Typography
- Font Family: Inter (Google Fonts)
- Various weights and sizes for hierarchy

### Components
- Custom buttons with rounded corners
- Card-based layouts with shadows
- Consistent spacing and padding
- Reusable form components

## Future Enhancements

- [ ] Data persistence with local database
- [ ] User authentication with backend
- [ ] Cloud synchronization
- [ ] Budget tracking and alerts
- [ ] Export functionality (PDF, CSV)
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Push notifications
- [ ] Biometric authentication

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.

---

**Built with ❤️ using Flutter**