# 📘 Developer Guide - ECG Flutter Project

Welcome to the **ECG Flutter Project**! This document provides a step-by-step guide for new developers on how to set up the project, where to make changes, and the process of committing and merging code via **Pull Requests (PRs)**.

---

## 📌 Table of Contents
1. [🚀 Getting Started](#-getting-started)
2. [📂 Where to Make Changes in Android](#-where-to-make-changes-in-android)
3. [🔄 Commands to Run Before Every Commit](#-commands-to-run-before-every-commit)
4. [🔀 How to Create a Pull Request (PR)](#-how-to-create-a-pull-request-pr)
5. [🏃 Running the App](#-running-the-app)
6. [🛠️ Contributing Guidelines](#-contributing-guidelines)
7. [📞 Need Help?](#-need-help)

---

## 🚀 Getting Started

### 1. Clone the Repository
To get started, clone the project from GitHub:

   ```bash
   git clone git@github.com:your-username/ecg-project.git
   cd ecg-project
   ```

### 2. Install Dependencies
Before running the project, install all required dependencies:

   ```bash
   flutter pub get
   ```

### 3. Setup for Android Development
Ensure you have:
- **An emulator or physical device connected**

Check available devices:
   ```bash
   flutter devices
   ```

---

## 📂 Where to Make Changes in Android

To modify **native Android code**, navigate to:
```
android/app/src/main/
```

- **`AndroidManifest.xml`** → Modify Android permissions and meta-data.
- **`MainActivity.kt`** → Modify the main entry point of the Android app.
- **`res/`** → Store custom icons, images, and UI resources.
- **`gradle.properties` & `build.gradle`** → Modify Android build configurations.

To build the Android app:
   ```bash
   flutter build apk
   ```

---

## 🔄 Commands to Run Before Every Commit

Before committing code, ensure the project is formatted, analyzed, and tested.

### 1. Format the Code
   ```bash
   flutter format .
   ```

### 2. Analyze for Errors & Warnings
   ```bash
   flutter analyze
   ```

### 3. Run Tests (If Available)
   ```bash
   flutter test
   ```

### 4. Ensure Dependencies Are Up to Date
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

### 5. Commit and Push Your Changes
After making changes, use the following commands:

   ```bash
   git add .
   git commit -m "Your meaningful commit message"
   git push origin your-branch-name
   ```

---

## 🔀 How to Create a Pull Request (PR)

Once your changes are pushed to a branch, follow these steps:

### 1. Create a New Branch
Before making changes, always create a new branch from `main`:
   ```bash
   git checkout -b feature-your-feature-name
   ```

### 2. Push Your Changes
After making modifications:
   ```bash
   git pull origin main --rebase
   git add .
   git commit -m "Describe your changes"
   git push origin feature-your-feature-name
   ```

### 3. Create a PR on GitHub
1. Go to your repository on **GitHub**.
2. Navigate to the **"Pull Requests"** tab.
3. Click **"New Pull Request"**.
4. Select your branch (`feature-your-feature-name`) and compare it with `main`.
5. Write a **clear description** of what your changes do.
6. Click **"Create Pull Request"**.

### 4. PR Review & Merge
- A team member will **review your PR**.
- After approval, it will be **merged into `main`**.
- 🎉 **Your code is now part of the project!**

---

## 🏃 Running the App

### 1. For Android
   ```bash
   flutter run -d android
   ```

### 2. For iOS
   ```bash
   flutter run -d ios
   ```

### 3. For Web
   ```bash
   flutter run -d chrome
   ```

### 4. For All Available Devices
   ```bash
   flutter devices
   flutter run -d <device_id>
   ```

---

## 🛠️ Contributing Guidelines
- Always **create a new branch** for new features or bug fixes.
- **Follow code formatting rules** (`flutter format .`).
- Write **clear commit messages**.
- Always **test your code** before submitting a PR.

---
