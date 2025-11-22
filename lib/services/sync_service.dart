import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/user_repository.dart';

final syncServiceProvider = Provider((ref) => SyncService(ref));

class SyncService {
  final Ref _ref;
  final List<Map<String, dynamic>> _pendingActions = [];
  Timer? _syncTimer;

  SyncService(this._ref) {
    _init();
  }

  void _init() {
    // Load pending actions from local storage (mock)
    // Start sync timer
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      syncPendingActions();
    });
  }

  void queueAction(String type, Map<String, dynamic> data) {
    _pendingActions.add({'type': type, 'data': data, 'timestamp': DateTime.now().toIso8601String()});
    // Save to local storage
    syncPendingActions(); // Try to sync immediately
  }

  Future<void> syncPendingActions() async {
    if (_pendingActions.isEmpty) return;

    // Check connectivity (mock)
    bool isOnline = true; 
    if (!isOnline) return;

    final List<Map<String, dynamic>> processed = [];

    for (final action in _pendingActions) {
      try {
        switch (action['type']) {
          case 'claimReferral':
            await _ref.read(userRepositoryProvider).claimReferral(
              action['data']['code'], 
              action['data']['newUserUid']
            );
            break;
          case 'updateUser':
            await _ref.read(userRepositoryProvider).updateUser(
              action['data']['uid'], 
              action['data']['data']
            );
            break;
        }
        processed.add(action);
      } catch (e) {
        print('Sync failed for action: ${action['type']} - $e');
        // Keep in queue if retryable
      }
    }

    _pendingActions.removeWhere((e) => processed.contains(e));
    // Update local storage
  }
}
