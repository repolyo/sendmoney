# SendMoney App

A Flutter-based mobile application for securely sending and tracking money transactions using Cubit (Bloc) for state management and service-based architecture for API integration.

## Requirements
Create a Send Money application that has 4 screens:

## 1st Screen - Login Screen
- Simple username and password authentication

## 2nd Screen Should Display the ff:
- Wallet Balance with show/hide icon
- Send Money button
- View Transactions Button

## 3rd Screen Should Display the ff:
- Textfield that accepts numbers
- Submit Button
- Bottom Sheet on Success/Error (after clicking submit button)

## 4th Screen Should Display the ff:
- Transaction History

# Business logic

## 1st Screen - Login Screen
- User should be able to login and logout of the application
- The user should be able to sign out in any of the succeeding screens

## 2nd Screen Should Display the ff:
- It should show the user's current balance (e.g. 500.00php)
- Clicking show/hide icon should hide the amount (e.g.******) and vice versa
- Clicking send money button should open the 3nd screen
- Clicking view transactions button should open the 4rd screen

## 3rd Screen Should Display the ff:
- User should enter the amount he/she wants to send. Textfield should only accept numbers.
- Clicking submit button should show a bottom sheet to indicate success/failure

## 4th Screen Should Display the ff:
- This screen should show all the transactions made by the user. Should show details like the amount sent.

##  Architecture Overview

The application follows a clean architecture pattern, separating concerns into:
- **Cubits** for state management (`AuthCubit`, `WalletCubit`)
- **Services** for backend communication (`UserService`, `WalletService`)
- **Models** for data structure (`User`, `Transaction`)

> View the App Architecture:
👉 [Architecture Documentation](docs/architecture.md)

> View the full class diagram:
👉 [Class Diagram Documentation](docs/class_diagram.md)

##  Features
- User login/logout with authentication API
- Wallet balance tracking
- Send money with description and amount validation
- Transaction history log
- Offline state management with Bloc/Cubit


## Testing
Includes unit tests for:
- Authentication logic
- Wallet transactions and validations

---

## Tech Stack
- Flutter + Dart
- flutter_bloc
- http (REST client)
- bloc_test & mocktail for testing

## Folder  Structure
```text
lib/
├── main.dart
├── blocs/                             # Cubit and state management
│   ├── auth_bloc.dart
│   └── wallet_bloc.dart
├── widgets/                        # Reusable UI widgets
│   ├── app_button.dart
│   ├── app_scaffold.dart
├── screens/                        # App pages like Login, Dashboard, SendMoney
│    ├── login_screen.dart
│    ├── dashboard_screen.dart
│    ├── send_screen.dart
│    └── history_screen.dart
├── models/                         # User and Transaction data classes
│   ├── user.dart
│   └── transaction.dart
├── services/                       # API service layers
   ├── user_service.dart
   └── wallet_service.dart
```