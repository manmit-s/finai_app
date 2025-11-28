# FinAI - AI-Powered Personal Finance Advisor

A modern, production-quality Flutter application for intelligent personal finance management with AI-powered insights.

## 🌟 Features

- **Financial Health Score**: Real-time calculation and visualization of your financial health
- **Smart Transaction Tracking**: Automatic categorization of expenses from SMS and bank data
- **Spending Analytics**: Visual charts and insights into spending patterns
- **AI Assistant**: Conversational interface for personalized financial advice
- **Anomaly Detection**: Real-time monitoring for suspicious transactions
- **Budget Management**: Track expenses against set budgets

## 🏗️ Project Structure

```
lib/
├── main.dart                                    # App entry point
├── theme/
│   └── app_theme.dart                          # Centralized theme configuration
├── widgets/
│   └── bottom_nav_scaffold.dart                # Bottom navigation scaffold
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── home_page.dart                  # Dashboard/home screen
│   │       └── widgets/
│   │           ├── financial_health_card.dart  # Health score widget
│   │           ├── stat_card.dart              # Reusable stat card
│   │           ├── spending_chart.dart         # Bar chart for spending
│   │           └── transaction_list_item.dart  # Transaction list item
│   └── chat/
│       └── presentation/
│           ├── chat_page.dart                  # AI assistant screen
│           └── widgets/
│               ├── chat_message_bubble.dart    # Message bubble widget
│               └── quick_reply_chip.dart       # Quick reply chip widget
```

## 🎨 Design System

### Color Palette
- **Primary**: Blue tones (#1E88E5) - Finance & tech feel
- **Secondary**: Teal (#26A69A) - Accent color
- **Success**: Green (#4CAF50) - Positive actions
- **Warning**: Orange (#FF9800) - Alerts
- **Danger**: Red (#E53935) - Negative values

### Typography
- Professional yet friendly font choices
- Clear hierarchy with proper weights
- Responsive sizing

### UI Elements
- Material 3 design
- Rounded cards (16px radius)
- Subtle shadows and gradients
- Smooth animations and transitions

## 📱 Screens

### 1. Home (Dashboard)
- Greeting header with user avatar
- Financial Health Score with circular progress
- Quick stats: Total spend, Savings, Upcoming bills
- Spending overview chart by category
- Recent transactions list
- AI-powered insights card

### 2. AI Assistant
- Chat interface with message bubbles
- Quick reply suggestions
- Real-time AI responses
- Financial advice and insights

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
```bash
git clone https://github.com/manmit-s/finai_app.git
cd finai
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run analyzer:
```bash
flutter analyze
```

## 📦 Dependencies

- `flutter`: SDK
- `cupertino_icons`: iOS-style icons
- `intl`: Internationalization and date formatting

## 🎯 Future Enhancements

- [ ] Real backend integration with NLP
- [ ] SMS parsing for transaction extraction
- [ ] Bank API integration
- [ ] ML-based spending predictions
- [ ] Custom budget creation
- [ ] Export reports (PDF, CSV)
- [ ] Multi-currency support
- [ ] Dark mode refinements
- [ ] Biometric authentication

## 🏛️ Architecture

The app follows a clean architecture pattern:
- **Presentation Layer**: UI components and widgets
- **Feature-based organization**: Each feature has its own folder
- **Reusable components**: Widgets are modular and composable
- **Theme centralization**: All styling in one place

## 👨‍💻 Development

### Code Style
- Null-safety enabled
- Proper widget composition
- Clear separation of concerns
- Descriptive naming conventions
- Comprehensive comments

### Best Practices
- StatelessWidget for static UI
- StatefulWidget for interactive components
- Custom painters for complex graphics
- Responsive layouts
- Performance optimizations

## 📄 License

This project is for hackathon purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Built with ❤️ using Flutter**
