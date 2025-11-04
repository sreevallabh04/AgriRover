import 'dart:async';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  bool _connected = false;

  bool get isConnected => _connected;

  Future<void> connect(String uri) async {
    if (isConnected) return;
    // Stub implementation - database connection disabled
    _connected = true;
  }

  Future<List<List<dynamic>>> query(String sql,
      {Map<String, dynamic>? params}) async {
    if (!isConnected) {
      throw StateError('Database not connected');
    }
    // Return empty results for stub
    return [];
  }

  Future<void> close() async {
    _connected = false;
  }
}
