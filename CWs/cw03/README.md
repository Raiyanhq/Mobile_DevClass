# CW03 - Firebase CRUD Task Manager

## Overview
This project is a Flutter task management app built for CSC 4360 Mobile App Development. It uses Firebase Firestore for real-time cloud storage and supports full CRUD operations on tasks, including nested subtasks.

## Features
- Add tasks
- Read tasks in real time using StreamBuilder
- Mark tasks complete/incomplete
- Delete tasks
- Add and delete nested subtasks

## Enhanced Features
1. Real-time search/filter for tasks
2. Expandable nested subtask interface

## Technologies Used
- Flutter
- Dart
- Firebase Core
- Cloud Firestore

## Setup Instructions
1. Clone the repository
2. Open the CW03 folder
3. Run `flutter pub get`
4. Run `flutterfire configure`
5. Enable Firestore in Firebase Console
6. Run `flutter run`

## Firestore Rules Used for Development
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{document=**} {
      allow read, write: if true;
    }
  }
}