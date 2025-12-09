import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:arbtilant/Services/hive_service.dart';
import 'package:arbtilant/Services/supabase_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  final HiveService _hiveService = HiveService();
  final SupabaseService _supabaseService = SupabaseService();
  final Connectivity _connectivity = Connectivity();

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  /// Start periodic sync
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    Future.delayed(interval, () async {
      await syncPendingItems();
      startPeriodicSync(interval: interval);
    });
  }

  /// Sync all pending items
  Future<void> syncPendingItems() async {
    final isOnline = await _isOnline();
    if (!isOnline) {
      print('Offline: Skipping sync');
      return;
    }

    try {
      // Sync pending feedback
      await _syncPendingFeedback();

      // Sync pending scan results
      await _syncPendingScanResults();

      print('Sync completed successfully');
    } catch (e) {
      print('Sync error: $e');
    }
  }

  /// Sync pending feedback
  Future<void> _syncPendingFeedback() async {
    try {
      final pendingFeedback = await _hiveService.getPendingFeedback();

      for (var feedback in pendingFeedback) {
        try {
          await _supabaseService.saveFeedback(feedback);
          await _hiveService.markFeedbackAsSynced(feedback.id);
          print('Synced feedback: ${feedback.id}');
        } catch (e) {
          print('Failed to sync feedback ${feedback.id}: $e');
        }
      }
    } catch (e) {
      print('Error syncing feedback: $e');
    }
  }

  /// Sync pending scan results
  Future<void> _syncPendingScanResults() async {
    try {
      late final List<dynamic> pendingScans;
      try {
        pendingScans = await _hiveService.getPendingScanResults();
      } catch (e) {
        print('Error getting pending scans: $e');
        print('Skipping scan results sync');
        return;
      }

      for (var scan in pendingScans) {
        try {
          await _supabaseService.saveScanResult(scan);
          await _hiveService.markScanResultAsSynced(scan.id);
          print('Synced scan result: ${scan.id}');
        } catch (e) {
          print('Failed to sync scan result ${scan.id}: $e');
        }
      }
    } catch (e) {
      print('Error syncing scan results: $e');
    }
  }

  /// Check if online
  Future<bool> _isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Listen to connectivity changes
  void listenToConnectivityChanges(
    Function(bool isOnline) onConnectivityChanged,
  ) {
    _connectivity.onConnectivityChanged.listen((result) {
      final isOnline = !result.contains(ConnectivityResult.none);
      onConnectivityChanged(isOnline);

      if (isOnline) {
        print('Online: Starting sync');
        syncPendingItems();
      } else {
        print('Offline: Queuing operations');
      }
    });
  }

  /// Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      final pendingFeedback = await _hiveService.getPendingFeedback();
      final pendingScans = await _hiveService.getPendingScanResults();
      final isOnline = await _isOnline();

      return {
        'is_online': isOnline,
        'pending_feedback': pendingFeedback.length,
        'pending_scans': pendingScans.length,
        'last_sync': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'is_online': false,
        'pending_feedback': 0,
        'pending_scans': 0,
        'error': e.toString(),
      };
    }
  }

  /// Force immediate sync (for debugging/manual trigger)
  Future<Map<String, dynamic>> forceSyncNow() async {
    print('=== FORCE SYNC STARTED ===');
    final startTime = DateTime.now();

    try {
      final isOnline = await _isOnline();
      print('Online status: $isOnline');

      if (!isOnline) {
        print('Device is offline, cannot sync');
        return {'success': false, 'message': 'Device is offline'};
      }

      // Get pending items before sync
      final pendingFeedbackBefore = await _hiveService.getPendingFeedback();
      final pendingScansBefore = await _hiveService.getPendingScanResults();

      print('Pending feedback before sync: ${pendingFeedbackBefore.length}');
      print('Pending scans before sync: ${pendingScansBefore.length}');

      // Sync feedback
      int feedbackSynced = 0;
      for (var feedback in pendingFeedbackBefore) {
        try {
          print('Syncing feedback: ${feedback.id}');
          await _supabaseService.saveFeedback(feedback);
          await _hiveService.markFeedbackAsSynced(feedback.id);
          feedbackSynced++;
          print('✓ Synced feedback: ${feedback.id}');
        } catch (e) {
          print('✗ Failed to sync feedback ${feedback.id}: $e');
        }
      }

      // Sync scan results
      int scansSynced = 0;
      for (var scan in pendingScansBefore) {
        try {
          print('Syncing scan: ${scan.id}');
          await _supabaseService.saveScanResult(scan);
          await _hiveService.markScanResultAsSynced(scan.id);
          scansSynced++;
          print('✓ Synced scan: ${scan.id}');
        } catch (e) {
          print('✗ Failed to sync scan ${scan.id}: $e');
        }
      }

      final duration = DateTime.now().difference(startTime);
      print('=== FORCE SYNC COMPLETED ===');
      print('Duration: ${duration.inSeconds}s');
      print('Feedback synced: $feedbackSynced');
      print('Scans synced: $scansSynced');

      return {
        'success': true,
        'feedback_synced': feedbackSynced,
        'scans_synced': scansSynced,
        'duration_seconds': duration.inSeconds,
      };
    } catch (e) {
      print('=== FORCE SYNC FAILED ===');
      print('Error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}
