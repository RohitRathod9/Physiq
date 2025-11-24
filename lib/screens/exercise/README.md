# Exercise Module & MET Calculation

This module handles exercise tracking, calorie estimation, and logging for the Physiq app.

## MET Table (Metabolic Equivalent of Task)

We use standard MET values to estimate calories burned.

| Activity | Intensity | MET |
|----------|-----------|-----|
| Run | Low | 6.0 |
| Run | Medium | 9.8 |
| Run | High | 11.5 |
| Cycling | Low | 4.0 |
| Cycling | Medium | 7.5 |
| Cycling | High | 10.0 |
| Weightlifting | Low | 3.0 |
| Weightlifting | Medium | 5.0 |
| Weightlifting | High | 6.0 |
| Push-ups | - | 8.0 |
| Squats | - | 5.5 |
| HIIT | - | 10.0 |

## Calorie Calculation Formula

The formula used is:

```
Calories = MET * 3.5 * Weight(kg) / 200 * Duration(minutes)
```

### Example

**User:** 70 kg
**Activity:** Running (Medium Intensity, MET 9.8)
**Duration:** 30 minutes

```
Calories = 9.8 * 3.5 * 70 / 200 * 30
Calories = 34.3 * 70 / 200 * 30
Calories = 2401 / 200 * 30
Calories = 12.005 * 30
Calories = 360.15 kcal
```

## Offline Sync

Logs are attempted to be sent to Firestore immediately. If the device is offline or the call fails, the log is serialized to JSON and stored in `SharedPreferences` under `pending_exercise_logs`. The `syncPendingLogs()` method should be called on app startup or connectivity restoration to flush this queue.
