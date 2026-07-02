import 'package:cloud_firestore/cloud_firestore.dart';

/// Per-user state sync. Progress and preferences live locally in
/// SharedPreferences and are mirrored to `users/{uid}` so they survive
/// reinstalls and follow the user across devices.
abstract class CloudStore {
  /// Loads the synced state map for [uid] (pref-style keys), or null if the
  /// user has no cloud document yet.
  Future<Map<String, Object?>?> load(String uid);

  /// Merges [state] (pref-style keys) into the user's cloud document.
  Future<void> save(String uid, Map<String, Object?> state);
}

class FirestoreCloudStore implements CloudStore {
  FirestoreCloudStore(this._db);

  final FirebaseFirestore _db;

  // Firestore treats '.' in field paths as nesting, so pref keys like
  // 'pref.darkMode' are stored with '_' and mapped back on load. No pref key
  // contains '_' of its own.
  static String _encode(String key) => key.replaceAll('.', '_');
  static String _decode(String key) => key.replaceAll('_', '.');

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Future<Map<String, Object?>?> load(String uid) async {
    final snapshot = await _doc(uid).get();
    final state = snapshot.data()?['state'];
    if (state is! Map<String, dynamic>) return null;
    return {
      for (final entry in state.entries) _decode(entry.key): entry.value,
    };
  }

  @override
  Future<void> save(String uid, Map<String, Object?> state) {
    return _doc(uid).set({
      'state': {
        for (final entry in state.entries) _encode(entry.key): entry.value,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
