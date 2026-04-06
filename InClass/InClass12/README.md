# Inventory Management App with Firestore

This project was created for Mobile App Development - In-Class Activity #12. The app is a real-time Flutter inventory manager that uses Firebase Firestore and clean architecture concepts to support CRUD operations with a responsive UI.

## Features
- Add inventory items to Firestore
- Read items in real time using `StreamBuilder`
- Update existing items
- Delete items
- Form validation for empty, invalid, negative, and non-numeric values
- Clean separation between model, service, and UI layers

## Enhanced Features
1. **Search by item name or category**  
   Users can quickly filter the list without reloading the app.

2. **Inventory insights + low stock alerts**  
   The app shows summary chips for total items, low-stock items, and total inventory value. Items with quantity less than or equal to 5 are flagged with a low stock warning.

## Project Structure
```text
lib/
  models/
    item_model.dart
  services/
    firestore_service.dart
  widgets/
    item_form_sheet.dart
  main.dart
```

## Dependencies
Add these packages to `pubspec.yaml`:
- `firebase_core`
- `cloud_firestore`

## Firebase Setup
1. Create a new Flutter app.
2. Run FlutterFire configuration.
3. Add the generated Firebase config files to the project.
4. Enable Firestore in test mode for development.
5. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Validation Rules
- Name cannot be empty
- Category cannot be empty
- Quantity must be a valid whole number and cannot be negative
- Price must be a valid decimal number and cannot be negative

## Test Checklist
- Add item works
- Edit item works
- Delete item works
- Real-time list updates without refresh
- Validation blocks bad input
- Empty state appears when there are no items
- Error state is shown if the stream fails

## Suggested Commit History
- `setup flutter app and firebase`
- `add inventory item model`
- `implement firestore service`
- `build streambuilder inventory list`
- `add form validation and CRUD`
- `add search and low stock insights`
- `write README and reflection`

## Reflection Summary
I expected `StreamBuilder` to update the UI automatically when Firestore changed, and that is what I obtained in testing. The strongest part of the project was the live synchronization between Firestore and the app. The hardest part was organizing CRUD cleanly without mixing Firestore logic into the UI. Separating the service layer improved readability and maintainability.