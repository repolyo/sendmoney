# SendMoney App

A Flutter-based mobile application for securely sending and tracking money transactions using Cubit (Bloc) for state management and service-based architecture for API integration.

##  Getting Started
Follow these steps to set up and run the **SendMoney App** locally:
```bash
git clone https://github.com/repolyo/sendmoney.git # clone repository
cd sendmoney
flutter pub get  # install dependencies
flutter test # run unit tests
flutter run # run the app
```

##  Architecture Overview

The application follows a clean architecture pattern, separating concerns into:
- **Cubits** for state management (`AuthCubit`, `WalletCubit`)
- **Services** for backend communication (`UserService`, `WalletService`)
- **Models** for data structure (`User`, `Transaction`)

> View the App Architecture:
👉 [Architecture Documentation](docs/architecture.md)

> View the class diagram:
👉 [Class Diagram](docs/class_diagram.md)

> View backend models:
👉 [Mock backend](docs/mockend_backend.md)
 
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
```bash
flutter test # execute all unit tests
```
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
│   └── app_scaffold.dart
├── screens/                        # App pages like Login, Dashboard, SendMoney
│    ├── login_screen.dart
│    ├── dashboard_screen.dart
│    ├── send_screen.dart
│    └── history_screen.dart
├── models/                         # User and Transaction data classes
│   ├── user.dart
│   └── transaction.dart
├── services/                       # API service layers
│   ├── user_service.dart
│   └── wallet_service.dart
├── extensions/                   # Dart extensions for common utilities
│   └── number_formatting.dart 
docs/                                   # Documentation files
├── architecture.md               # Architecture overview
├── class_diagram.md            # Class diagram
└── mockend_backend.md     # Mock backend setup
test/                                   # Unit tests
├── blocs/
│   ├── auth_cubit_test.dart
│   └── wallet_cubit_test.dart
├── screens/
│   └── send_screen_test.dart
└── services/
    ├── user_service_test.dart
    └── wallet_service_test.dart
```

##  Mock Backend Setup with Mockend

This project uses [**Mockend**](https://mockend.com) to simulate a backend API for development and testing purposes.

### Base API URL
The base URL for the Mockend API is:
```
https://mockend.com/api/repolyo/sendmoney-api/
```

### Mock Data Structure
Mockend uses a GitHub repository (`repolyo/sendmoney-api`) to define fake data models.
See [docs/mockend_backend.md](docs/mockend_backend.md) for the mock database structure, endpoints, and sample data.

Available endpoints:
- **Users**: `GET /user`
- **Wallets**:
    - `GET /wallet`
    - `POST /wallet`
- **Transactions**:
    - `GET /transaction`
    - `POST /transaction`

### Sample User for Testing
```json
{
  "id": 1,
  "name": "Christopher Tan",
  "email": "tanch@test.com",
  "password": "test1234"
}
```
Or use any from the mock data provided in the repository.
```bash
# To fetch all users from the mock backend
curl https://mockend.com/api/repolyo/sendmoney-api/user
```

### Requirements
Create a Send Money application that has 4 screens:

#### 1st Screen - Login Screen
- Simple username and password authentication

#### 2nd Screen Should Display the ff:
- Wallet Balance with show/hide icon
- Send Money button
- View Transactions Button

#### 3rd Screen Should Display the ff:
- Textfield that accepts numbers
- Submit Button
- Bottom Sheet on Success/Error (after clicking submit button)

#### 4th Screen Should Display the ff:
- Transaction History

### Business logic

#### 1st Screen - Login Screen
- User should be able to login and logout of the application
- The user should be able to sign out in any of the succeeding screens

#### 2nd Screen Should Display the ff:
- It should show the user's current balance (e.g. 500.00php)
- Clicking show/hide icon should hide the amount (e.g.******) and vice versa
- Clicking send money button should open the 3nd screen
- Clicking view transactions button should open the 4rd screen

#### 3rd Screen Should Display the ff:
- User should enter the amount he/she wants to send. Textfield should only accept numbers.
- Clicking submit button should show a bottom sheet to indicate success/failure

#### 4th Screen Should Display the ff:
- This screen should show all the transactions made by the user. Should show details like the amount sent.



