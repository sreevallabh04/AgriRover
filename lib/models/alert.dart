enum AlertType { warning, error, info, success }

enum AlertPriority { low, medium, high, critical }

class Alert {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final AlertPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final bool isResolved;

  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    required this.isRead,
    required this.isResolved,
  });

  Alert copyWith({
    String? id,
    String? title,
    String? message,
    AlertType? type,
    AlertPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    bool? isResolved,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isResolved: isResolved ?? this.isResolved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isResolved': isResolved,
    };
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: AlertType.values.firstWhere((e) => e.name == json['type']),
      priority:
          AlertPriority.values.firstWhere((e) => e.name == json['priority']),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      isResolved: json['isResolved'],
    );
  }
}
