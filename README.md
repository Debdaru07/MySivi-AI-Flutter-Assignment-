# MySivi AI – Mini Chat Application (Flutter)

A minimal yet well-structured Flutter chat application built as part of the **MySivi AI Flutter Assignment**.  
The project demonstrates clean architecture, state management, UI consistency, and testability.

---

## 📱 Overview

This application simulates a chat experience with:

- A user list
- Persistent tab navigation
- Chat history per user
- API-driven receiver messages
- Clean and scalable Flutter architecture

The focus of this assignment is **code quality, structure, and UX clarity**, not just visual polish.

---

## ✨ Features

- 🧑‍🤝‍🧑 **User List Screen**

  - Displays available users
  - Navigates to individual chat screens

- 💬 **Chat Screen**

  - User-specific chat history
  - Sender & receiver message separation
  - API-triggered automated replies

- 🧭 **Custom Bottom Navigation**

  - Chats
  - Offers (placeholder)
  - Settings (placeholder)
  - State preserved across tab switches

- 🧠 **State Management**

  - Built using **Riverpod**
  - Providers separated by feature

- 🧪 **Testing**
  - Unit tests for providers
  - Mocked API & DB services using `mocktail`

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   └── widgets/
│       ├── custom_bottom_nav.dart
│       └── empty_state.dart
│
├── features/
│   ├── users/
│   │   ├── data/
│   │   │   ├── users_api_service.dart
│   │   │   ├── users_db_service.dart
│   │   │   └── users_api_provider.dart
│   │   │
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   │
│   │   ├── state/
│   │   │   └── users_provider.dart
│   │   │
│   │   └── ui/
│   │       ├── users_screen.dart
│   │       └── user_tile.dart
│   │
│   ├── chat/
│   │   ├── data/
│   │   │   ├── chat_api_service.dart
│   │   │   └── chat_db_service.dart
│   │   │
│   │   ├── models/
│   │   │   └── message_model.dart
│   │   │
│   │   ├── state/
│   │   │   └── chat_provider.dart
│   │   │
│   │   └── ui/
│   │       ├── chat_screen.dart
│   │       └── message_bubble.dart
│   │
│   ├── offers/
│   │   └── offers_screen.dart
│   │
│   └── settings/
│       └── settings_screen.dart
│
├── main.dart
│
test/
├── features/
│   ├── users/
│   │   └── users_provider_test.dart
│   │
│   └── chat/
│       └── chat_provider_test.dart
```

---

## 🧩 Architecture

- **Feature-first structure**
- Clear separation of:
  - UI
  - State
  - Data sources (API / DB)
- Easily extendable for real backend integration

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Riverpod**
- **Flutter Test**
- **Mocktail**

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (compatible with the Flutter version)
- Android Studio / Xcode / VS Code
- A connected device or emulator

---

### Step 2: Install Dependencies

Fetch all required Flutter packages:

```bash
flutter pub get
```

---

### Step 3: Run the Application

Launch the app on a connected device or emulator:

```bash
flutter run
```

---

### Step 4: Run Tests

Fetch all required Flutter packages:

```bash
flutter test
```

---

### Step 5: Analyze Code (Optional)

Run static analysis to ensure code quality:

```bash
flutter analyze
```

---

### Step 6: Build the Application (Optional)

#### Android APK:

```bash
flutter build apk
```

#### Android App Bundle:

```bash
flutter build appbundle
```

#### iOS (macOS only):

```bash
flutter build ios
```

---

### Step 7: Clean the Project (Optional)

Reset build artifacts if needed:

```bash
flutter clean
flutter pub get
```

---
