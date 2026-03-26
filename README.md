# Task Master

Task Master is a premium, beautifully designed task management application built entirely in Flutter for Android. It uses a modern aesthetic inspired by Apple and Google's latest design languages, featuring edge-to-edge screens, fluid animations, and a rich dark mode ("Midnight").

## 🚀 Features

- **Morning Briefing:** A curated view of your most important task for the day, or a "caught up" state if everything is clear.
- **Fluid Animations:** Powered by `flutter_animate` to provide smooth, premium transitions on all list items and interactions.
- **Dynamic Profile Card:** A shareable user profile that calculates a rank and weekly efficiency based on your completed tasks. Customize your profile picture, edit your name, and share it as an image snippet!
- **Edge-to-Edge UI:** Makes full use of the Android screen space, drawing cleanly under system navigation bars.
- **Deep Midnight Mode:** A beautifully crafted dark theme utilizing deep blues and slate grays, togglable from the Profile screen.
- **Custom Categories:** Add and long-press to delete customized tag categories.
- **Inline Search:** Real-time search that seamlessly takes over the title bar area and displays results inline above your task feed.

## 🏗️ Architecture and State Management

Task Master uses the **Provider** pattern to manage application state across three distinct domains:

### 1. `TaskProvider` (`lib/providers/task_provider.dart`)
- **Role:** Handles CRUD operations for all tasks.
- **Data flow:** Reads/writes to the local SQLite database (`lib/services/db_helper.dart`).
- **Features:** Separates tasks into `todayTasks`, `upcomingTasks`, and `completedTasks`. Also maintains a list of `searchResults` when a query is active.

### 2. `UserProvider` (`lib/providers/user_provider.dart`)
- **Role:** Manages the user's profile metadata.
- **Data flow:** Reads/writes to the device using `SharedPreferences` (`lib/services/prefs_service.dart`).
- **Features:** Stores the `userName`, `joinDate`, `profileImagePath`, and a customizable list of `categories`.

### 3. `ThemeProvider` (`lib/providers/theme_provider.dart`)
- **Role:** Controls the app's visual mode (Light/Dark).
- **Data flow:** Reads/writes boolean values using `SharedPreferences`.

## 📂 Project Structure Explained

- **`lib/main.dart`**: The entry point. Initializes system UI overlay styles (for edge-to-edge support) and wraps the app in the `MultiProvider`.
- **`lib/models/`**:
  - `task.dart`: The core data model representing a single to-do item.
- **`lib/providers/`**: Holds all the ChangeNotifier classes mentioned above.
- **`lib/screens/`**:
  - `main_layout.dart`: The scaffold containing the custom bottom navigation bar and the `IndexedStack` to switch between Home and Profile screens.
  - `home_screen.dart`: The main dashboard. Contains the Morning Briefing hero section, inline search logic, and categorized lists.
  - `profile_screen.dart`: The user settings and stat page. Houses the screenshot/share feature and the theme toggle.
  - `add_task_screen.dart`: The bottom sheet modal used for creating or editing a task.
- **`lib/services/`**:
  - `db_helper.dart`: The SQLite wrapper for standard queries.
  - `prefs_service.dart`: A wrapper for key-value pair storage.
- **`lib/widgets/`**:
  - Reusable UI components. Examples include `task_item.dart` (which contains its own animations), `custom_date_picker.dart`, and `add_category_sheet.dart`.

## 🛠️ How to Modify Specific Features

### Modifying the Visual Theme
1. Open `lib/main.dart`
2. Locate the `ThemeData` blocks within the `MaterialApp`.
3. You can modify core colors like `scaffoldBackgroundColor` or `primaryColor`.
4. For deeper component-level styling (e.g., gradient backgrounds on the hero cards), you'll need to modify the respective widget directly (e.g., `lib/screens/home_screen.dart`).

### Adding a New Data Field to a Task
1. Update `lib/models/task.dart` to include the new field (e.g., `final String priority;`).
2. Update the `toMap` and factory methods in `task.dart` to handle serialization.
3. Open `lib/services/db_helper.dart` and update the `_onCreate` method to add a new column to the SQL schema. Increment the `_dbVersion`.
4. Update `lib/screens/add_task_screen.dart` to add a UI input element (like a dropdown) for the user to select the new field.

### Editing the Ranking Logic
1. Open `lib/screens/profile_screen.dart`.
2. Locate the private method `_getRank(int completedTasks)`.
3. Adjust the threshold integers or string returns to match your desired gamification flow.

## ⚙️ Running Locally

```bash
# Get dependencies
flutter pub get

# Run the app on an Android emulator or device
flutter run
```

## 📦 Build Release

```bash
flutter build apk --release
```

## 💖 Credits
Made with love by Harshit, Anupam and Yash.