import 'dart:async';
import 'package:postgres/postgres.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  PostgreSQLConnection? _connection;
  Completer<void>? _connecting;

  bool get isConnected => _connection?.isClosed == false;

  Future<void> connect(String uri) async {
    if (isConnected) return;
    if (_connecting != null) return _connecting!.future;

    _connecting = Completer<void>();
    try {
      final parsed = Uri.parse(uri);
      final host = parsed.host;
      final port = parsed.hasPort ? parsed.port : 5432;
      final db = parsed.pathSegments.isNotEmpty ? parsed.pathSegments.last : '';
      final user = parsed.userInfo.split(':').first;
      final password =
          parsed.userInfo.contains(':') ? parsed.userInfo.split(':').last : '';
      final useSSL = (parsed.queryParameters['sslmode'] ?? '').isNotEmpty;

      final conn = PostgreSQLConnection(
        host,
        port,
        db,
        username: user,
        password: password,
        useSSL: useSSL,
      );
      await conn.open();
      _connection = conn;
      _connecting!.complete();
    } catch (e) {
      _connecting!.completeError(e);
      rethrow;
    } finally {
      _connecting = null;
    }
  }

  Future<List<List<dynamic>>> query(String sql,
      {Map<String, dynamic>? params}) async {
    if (!isConnected) {
      throw StateError('Database not connected');
    }
    return _connection!.query(sql, substitutionValues: params);
  }

  Future<void> close() async {
    if (_connection != null && _connection!.isClosed == false) {
      await _connection!.close();
    }
  }
}
