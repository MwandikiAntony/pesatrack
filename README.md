# PesaTrack

**PesaTrack** is a Flutter mobile app designed to help users manage and track their daily expenses efficiently.  
It features a modern, intuitive UI, analytics, budget alerts, and powerful filtering options.

---

##  Features

- **Add, Edit & Delete Expenses** – Manage your expenses easily.  
- **Filter by Category & Date Range** – Quickly find the expenses you want.  
- **Total Spending Summary** – See how much you've spent at a glance.  
- **Budget Alerts** – Highlights over-limit expenses in red.  
- **Analytics with Pie Chart** – Visualize spending by category.  
- **Dark Mode Support** – Works in system dark mode or manual toggle.  
- **Polished Empty States & UX Feedback** – Smooth and professional experience.

---

## Screenshots

| Home Screen | Add Expense | Edit Expense | Analytics | Dark Mode |
|------------|-------------|-------------|-----------|-----------|
| ![Home](assets/screenshots/home.png) | ![Add](assets/screenshots/add.png) | ![Edit](assets/screenshots/edit.png) | ![Analytics](assets/screenshots/analytics.png) | ![Dark](assets/screenshots/dark.png) |

> Replace these with your actual screenshots in `assets/screenshots/`.

---

## Tech Stack

- **Flutter & Dart** – Cross-platform mobile development.  
- **Hive** – Lightweight local database for storing expenses.  
- **Provider** – State management.  
- **FL_Chart** – Analytics charts.

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/pesatrack.git
cd pesatrack
```
2. Install dependencies:
```
flutter pub get
```
3. Run the app:

```
flutter run
```
4. Deployment
```
Android APK: build/app/outputs/flutter-apk/app-release.apk

Android AAB (Play Store): build/app/outputs/bundle/release/app-release.aab
```
Follow Flutter Android Deployment Docs for signed release builds.


## App Customization
- Change app name in android/app/src/main/AndroidManifest.xml.
- Update app icon using flutter_launcher_icons.


## dev_dependencies:
```
  flutter_launcher_icons: ^0.12.0

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

```
Run:
flutter pub run flutter_launcher_icons:main