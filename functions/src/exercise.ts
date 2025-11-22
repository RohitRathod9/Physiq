import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

export const computeExerciseCalories = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be logged in.');
  }

  const { uid, exerciseLog } = data;
  if (uid !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'User ID mismatch.');
  }

  // Fetch user weight
  const userDoc = await db.collection('users').doc(uid).get();
  const userData = userDoc.data();
  const weightKg = userData?.weightKg || 70; // Default if missing

  // Calculate canonical calories
  // Formula: MET * 3.5 * weight_kg / 200 * duration_minutes
  // We need to look up MET for the exerciseId, but for now we trust the log or use a default
  // In a real app, we would fetch the exercise doc to get the authoritative MET
  const met = 3.5; // Placeholder, should fetch from exerciseLibrary or passed in data if trusted
  const durationMinutes = exerciseLog.durationMinutes || 0;
  
  const canonicalCalories = met * 3.5 * weightKg / 200 * durationMinutes;

  // Update the log with canonical value
  // await db.collection('users').doc(uid).collection('exerciseLogs').doc(exerciseLog.id).update({
  //   canonicalCalories: canonicalCalories,
  //   canonicalCalculatedAt: admin.firestore.FieldValue.serverTimestamp(),
  // });

  return {
    canonicalCalories,
    delta: canonicalCalories - (exerciseLog.exerciseCalories || 0),
  };
});

export const aggregateUserExerciseStats = functions.https.onCall(async (data, context) => {
    // Placeholder for aggregation logic
    // 1. Sum total exerciseCalories for the week
    // 2. Compute activity points
    // 3. Write to stats summary doc
    return { success: true };
});

export const deleteExerciseData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be logged in.');
  }
  
  // Logic to delete all logs and library items for the user
  // Respect USE_MOCK_DELETE env var if set
  
  return { success: true };
});
