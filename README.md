### EasyVote

```markdown
# EasyVote

EasyVote is a mobile and web e-voting application designed for small-scale elections in organizations, schools, and churches. Built with Flutter, the app offers a streamlined process for administrators to set up elections and for voters to participate securely and conveniently.

You can access the web version of EasyVote at [https://easyvote-71ed8.web.app/](https://easyvote-71ed8.web.app/).

## Features

### Admin

- **Create Elections**: Admins can create elections, set titles, descriptions, and specify the voting period.
- **Manage Elections**: Edit or delete existing elections as needed.
- **Upload Voter IDs**: Admins can upload the list of eligible voters by their IDs.

### Voter

- **Login & Signup**: Voters can sign up or log in using their email, password, and voter ID.
- **View Elections**: Voters can see only the elections they are registered for.
- **Retrieve Voter ID**: Users can retrieve their voter ID by signing in with their email and password.

### Voting

- **Secure Voting**: Users can only vote in elections they are registered for.
- **View Results**: Election results can be viewed after the voting period ends.

## Web Access

In addition to the mobile version, EasyVote is available as a web application. To access the web version, visit the following URL:

[https://easyvote-71ed8.web.app/](https://easyvote-71ed8.web.app/)

The web app offers the same features as the mobile version, allowing users to participate in elections, manage elections (for admins), and view results.

## Screenshots

Include screenshots of the app’s main screens (e.g., login, home screen, election details, voting screen, etc.).

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your local machine.
- [Firebase project](https://console.firebase.google.com/) set up and configured.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Atinuke-Manuels/Easy_Vote.git
   cd easyvote
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project.
   - Add your Android, iOS, and Web app to the Firebase project.
   - Download the `google-services.json` (Android) and `firebaseConfig` for Web, and place them in their respective directories:
      - `android/app/` for `google-services.json`
      - Use the `firebaseConfig` for web setup in the web directory.
   - Enable Firebase Authentication and Firestore.

4. **Run the app**
   ```bash
   flutter run
   ```

### Running on Web

To run the app on the web, make sure Flutter web is set up on your machine. Then, run:

```bash
flutter run -d chrome
```

You can also deploy the web app using Firebase Hosting. Follow these steps:

1. **Build the app for the web**
   ```bash
   flutter build web
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase deploy --only hosting
   ```

The web app will be live on the Firebase-hosted URL provided.

### Folder Structure

```plaintext
lib/
├── constants/         # Constants for styling and configuration
├── models/            # Models for representing data structures like Election
├── screens/           # Screens for the app (login, home, election details, etc.)
├── services/          # Firebase and other backend services
├── themes/            # Theme management for light and dark modes
├── widgets/           # Reusable widgets like buttons, text fields, etc.
└── main.dart          # Entry point of the application
```

## Configuration

### Firebase Setup

Make sure to configure Firebase in your project by adding your Firebase project's credentials (`google-services.json` for Android, `GoogleService-Info.plist` for iOS, and `firebaseConfig` for Web).

### Color Scheme and Themes

EasyVote supports both light and dark themes. To customize the color scheme:

- Edit the `ColorScheme` in `themes/theme_provider.dart`.

## Usage

### User Flow

1. **Login or Sign Up**: Users can create an account or log in using their email, password, and voter ID.
2. **View Available Elections**: Once logged in, voters can see the list of elections they are eligible to participate in.
3. **Vote**: During the voting period, users can cast their vote in the eligible elections.
4. **View Results**: Once the election ends, the results are displayed.

### Admin Flow

1. **Create an Election**: Admins can create a new election and set the title, description, and dates.
2. **Upload Voter List**: Admins upload a list of eligible voter IDs for the election.
3. **Monitor Election Progress**: Admins can track ongoing elections.
4. **View Results**: Results are displayed once voting is complete.

## Troubleshooting

- **No Elections Showing for Voter**: Ensure the voter ID is correctly registered in the Firestore database under the election's `registeredVoters` field.
- **Login Issues**: Verify email and password, and check that the user exists in Firebase Authentication.
- **Firebase Configuration Errors**: Ensure your `google-services.json`, `GoogleService-Info.plist`, or web `firebaseConfig` files are correctly placed in the project.

## Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License.

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)

---
```
