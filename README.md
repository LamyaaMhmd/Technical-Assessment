# UAE Phone Top-Up App

A Flutter application that allows users to manage top-up beneficiaries and perform top-up transactions for UAE phone numbers.

---

## Setup Instructions

### Prerequisites

- Flutter SDK `>=3.10.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code with Flutter plugin
- Android emulator or iOS simulator (or a physical device)

### Steps to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/Technical-Assessment__Public.git
   cd Technical-Assessment__Public
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

> No backend setup is required. The app uses a mock HTTP layer that simulates a real REST API using a Dio interceptor.

---

## Project Structure

```
lib/
├── core/
│   ├── error/                  # Failure classes
│   ├── network/
│   │   ├── api_client.dart     # Dio HTTP client
│   │   ├── mock_interceptor.dart  # Intercepts requests, returns mock responses
│   │   ├── mock_database.dart  # Singleton in-memory database
│   │   └── handlers/           # One handler per endpoint
│   │       ├── user_handler.dart
│   │       ├── beneficiary_handler.dart
│   │       ├── transaction_handler.dart
│   │       └── topup_handler.dart
│   ├── utils/
│   │   └── constants.dart      # App-wide constants
│   └── widgets/
│       └── shared_snackbar.dart
│
└── features/
    └── topup/
        ├── data/
        │   ├── datasources/    # HTTP calls + JSON parsing
        │   ├── models/         # fromJson / toJson
        │   └── repositories/   # Bridges data ↔ domain
        ├── domain/
        │   ├── entities/       # Pure Dart classes
        │   ├── repositories/   # Abstract contracts
        │   └── usecases/       # Business logic
        └── presentation/
            ├── bloc/           # State management (Bloc)
            ├── pages/          # BlocProvider setup
            └── widgets/        # UI components
```

---

## Architecture

This project follows **Clean Architecture** with three layers:

- **Data layer** — handles HTTP communication, JSON serialization, and repository implementation
- **Domain layer** — contains pure business logic, entities, and abstract repository contracts
- **Presentation layer** — manages UI and state using the **Bloc** pattern

### Mock HTTP Layer

Since the backend is not implemented, all HTTP requests are intercepted by `MockInterceptor` (a Dio interceptor). It simulates the following REST endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/user` | Returns the current user |
| GET | `/beneficiaries` | Returns all beneficiaries |
| POST | `/beneficiaries` | Adds a new beneficiary |
| GET | `/transactions` | Returns all transactions |
| POST | `/topup` | Performs a top-up transaction |

All state is held in `MockDatabase` — a singleton in-memory store that persists for the app's lifetime.

---

## Business Rules Implemented

| Rule | Details |
|------|---------|
| Max beneficiaries | 5 active beneficiaries per user |
| Nickname length | Maximum 20 characters |
| Top-up options | AED 5, 10, 20, 30, 50, 75, 100 |
| Transaction fee | AED 3 per transaction |
| Unverified user limit | AED 500 per beneficiary per calendar month |
| Verified user limit | AED 1,000 per beneficiary per calendar month |
| Total monthly limit | AED 3,000 across all beneficiaries |
| Balance check | User cannot top up more than their current balance (including fee) |

---

## Assumptions

1. **User verification** is managed by a separate feature. The `isVerified` flag is provided as a property on the `User` entity and seeded as `true` in the mock database.

2. **Monthly limits** are calculated per calendar month (e.g. March 1–31). Transactions from previous months do not count toward the current month's limit.

3. **Balance deduction** includes the AED 3 transaction fee. For example, a AED 50 top-up deducts AED 53 from the user's balance.

4. **Mock database** resets every time the app is restarted, since it is in-memory only. In production, this would be replaced by a real API.

5. **Phone number validation** assumes UAE format (`05XXXXXXXX` — 10 digits starting with `05`).

6. **Single user** — the app operates with one hardcoded user (id: `1`, balance: AED 5,000, verified: true). Multi-user support is out of scope.

---

## Running Unit Tests

1. **Run all tests**
   ```bash
   flutter test
   ```

2. **Run a specific test file**
   ```bash
   flutter test test/unit/usecases/topup_number_test.dart
   ```

3. **Run tests with coverage**
   ```bash
   flutter test --coverage
   ```

### What is tested

- `TopupNumber` usecase — balance validation, monthly limits, beneficiary limits
- `AddBeneficiary` usecase — max beneficiary enforcement, nickname validation
- `TopupBloc` — state transitions for loading, success, and error scenarios
- `UserModel`, `BeneficiaryModel`, `TransactionModel` — `fromJson` / `toJson` correctness

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `dio` | HTTP client |
| `equatable` | Value equality for Bloc states |

---

## State Management

The app uses **Bloc** for state management with a clear separation of events and states:

**Events:** `LoadInitialData`, `AddBeneficiaryEvent`, `TopupEventRequested`, `AddBeneficiaryPressed`

**States:** `TopupInitial`, `TopupLoading`, `TopupLoaded`, `TopupSuccess`, `TopupError`, `BeneficiaryLimitReached`, `CanAddBeneficiary`
