# CW03 Reflection

## 1. Objective + Expectation
The main objective of this assignment was to build a StatefulWidget-based Flutter application that uses Firebase Firestore for real-time CRUD operations. Before starting, I expected that using `setState()` would automatically refresh data from Firestore. While working on the app, I learned that `setState()` only rebuilds the local widget tree, while Firestore updates are delivered through `StreamBuilder`.

## 2. What I Obtained
I successfully built a task management app that supports creating, reading, updating, and deleting tasks stored in Firestore. The app also supports nested subtasks, input validation, and UX states such as loading, empty list, and error handling. Tasks remained available after restarting the app because the data was stored in Firestore instead of only in local state.

## 3. Evidence
The strongest evidence was that when I added a task in the app, it immediately appeared in the list without a manual refresh. When I checked the Firebase Firestore console, I could also see the same task stored in the `tasks` collection. My commit history also shows progress from setup, to model creation, to service layer, to UI wiring, to subtasks, and finally to polish.

## 4. Analysis
The app worked because I separated responsibilities across the model, service, screen, and widget files. The `Task` model handled conversion using `toMap()` and `fromMap()`, the `TaskService` handled Firestore operations, and the `HomeScreen` used `StreamBuilder` to listen for real-time updates. Validation was important because it prevented empty task names from being written to Firestore. One important lesson was understanding that Firestore streams control cloud-synced UI updates, while `setState()` is still useful for local UI changes such as search filtering and expansion behavior.

## 5. Improvement Plan
If I continued improving this app, the first change I would make is adding Firebase Authentication so each user has a private task list. That would improve security and make the app more realistic. I would also consider changing subtasks into separate structured objects instead of plain strings so they could support their own completion state.

## Critical Thinking Prompts

### 1. Which objective was easiest to achieve, and why?
The easiest objective was building the base UI. Creating the text field, add button, and list layout felt straightforward because Flutter widgets are well structured and I had already practiced building interfaces before.

### 2. Which objective was hardest, and what misconception did you correct?
The hardest objective was understanding real-time Firestore behavior. My misconception was thinking that `setState()` itself would fetch and refresh cloud data. I corrected that by learning that `StreamBuilder` listens to Firestore snapshots continuously.

### 3. Where did expected behavior not match obtained behavior, and how did you debug it?
At first, I expected task updates to always appear just because I changed widget state. Instead, I had to confirm that Firestore writes were actually happening correctly. I debugged this by using print statements, checking the Firestore console, and verifying the app behavior after each CRUD action.

### 4. How does your commit history show growth from a basic task list to a cloud-backed app?
My commit history starts with project setup and Firebase configuration, then adds the Task model, then the Firestore service layer, then the basic UI, then nested subtasks, and finally UX improvements. This shows a clear step-by-step progression instead of trying to build everything at once.

### 5. If this app scaled to thousands of tasks per user, what design change would you make first?
If the app had thousands of tasks, I would first improve the data architecture by adding pagination and better Firestore query design. I would also look into indexing and possibly a more structured state management pattern for better maintainability.