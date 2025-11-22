# Physiq Settings & Features

This document details the implementation of the Settings screen, Leaderboard, Invite system, and Backend functions.

## Features

1.  **Settings Screen**:
    *   Personal Details (Editable)
    *   Leaderboard (Rank, Top 10, Prizes)
    *   Invite Friend (Referral system)
    *   Preferences (Language, Theme - placeholders)
    *   Account Management (Logout, Delete)

2.  **Backend (Cloud Functions)**:
    *   `createInviteCode`: Generates unique referral codes.
    *   `claimReferral`: Processes referrals and awards credits.
    *   `recomputeLeaderboard`: Updates user score based on activity.
    *   `generateCanonicalPlan`: Server-side plan generation.
    *   `deleteUserData`: Secure account deletion.

## Developer Toggles

In `lib/services/auth_service.dart` (or `AppConfig` class):

*   `AppConfig.useMockBackend`: Set to `true` to run without Firebase (UI only). Set to `false` for production.
*   `AppConfig.mockDelete`: Set to `true` to prevent actual deletion during dev.

## Setup & Wiring

### Firebase

1.  Ensure `firebase-tools` is installed.
2.  Login: `firebase login`
3.  Initialize: `firebase init` (select Firestore, Functions).
4.  Deploy Functions: `firebase deploy --only functions`
5.  Deploy Firestore Rules: `firebase deploy --only firestore:rules`

### Running Locally

1.  **Flutter**:
    ```bash
    flutter run
    ```
2.  **Cloud Functions (Emulator)**:
    ```bash
    cd functions
    npm run serve
    ```

### Testing

*   **Flutter Tests**:
    ```bash
    flutter test test/leaderboard_test.dart
    flutter test test/settings_widget_test.dart
    ```
*   **Functions Tests**:
    ```bash
    cd functions
    npm test
    ```

## Data Models

*   **User**: `users/{uid}`
*   **Invite**: `invites/{code}`
*   **Leaderboard**: `leaderboards/global/users/{uid}`

## Leaderboard Scoring

Score = `(min(streakDays, 60) * 2.0) + (consistencyPct * 1.5) + activityPoints + engagementBonus`

*   **Streak**: Consecutive green days.
*   **Consistency**: % of non-red days in last 30.
*   **Activity**: Normalized exercise + steps + water.

## Referral System

*   Reward: ₹100 per valid referral.
*   Bonus: ₹500 after 5 referrals.
*   Logic: `claimReferral` function validates code and updates balances.
