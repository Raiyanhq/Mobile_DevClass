# Reflection Answers - In-Class Activity #12

## 1) Objective + Expectation
The main learning objective of this assignment was to build a Flutter inventory app that uses Firestore for cloud data and updates the UI in real time. Before I started, I expected `StreamBuilder` to keep the inventory list updated automatically without needing a manual refresh. I also expected the service layer to make the CRUD code cleaner and easier to manage.

## 2) What I Obtained
I obtained a working inventory app that supports create, read, update, and delete operations with Firestore. The list updates in real time when items are added, edited, or removed. I also added validation so invalid data does not get written to the database. The app includes loading, empty, and error states for better UX.

## 3) Evidence
The evidence would be the live Firestore collection updating in the app, the commit history showing separate setup and feature phases, and the visible UI behavior when testing add, edit, and delete actions. Another strong piece of evidence is that invalid form submissions are blocked with validation messages, and the list changes instantly after a Firestore write.

## 4) Analysis
The result happened because the data flow was separated clearly. The `InventoryItem` model handled object conversion, the `FirestoreService` handled CRUD and streaming, and the UI focused on display and user interaction. `StreamBuilder` listened to Firestore snapshots, which removed the need for manual refresh logic. Validation improved reliability because it prevented bad quantity and price values from being saved.

## 5) Improvement Plan
The next improvement I would make is adding authentication and role-based access so each user only sees their own inventory data. This would improve security and make the app more scalable for real-world use.

## Critical Thinking Prompts

### Which objective was easiest to achieve, and why?
The easiest objective was displaying data in real time because `StreamBuilder` works very well with Firestore snapshots. Once the stream was connected correctly, the UI updated automatically.

### Which objective was hardest, and what misconception did you correct?
The hardest objective was keeping the code organized while implementing CRUD. At first, it seemed easier to put Firestore code directly inside the UI, but I corrected that misconception by moving database logic into a dedicated service layer.

### Where did expected behavior not match obtained behavior, and how did you debug it?
At first, I expected all form input to work smoothly, but numeric parsing needed stronger validation. I debugged this by testing empty strings, letters, and negative values until the validation rules handled each case properly.

### How did your commit history show growth from basic functionality to polished architecture?
The commit history would show progress from setup, to the model, to Firestore service methods, then the live stream UI, and finally validation and enhanced features. This shows a clear move from basic functionality to a more polished and maintainable app.

### If this app scaled to many users/items, what design change would you make first?
The first design change would be pagination or query-based filtering in Firestore so the app does not load too many items at once. That would improve performance and scalability.