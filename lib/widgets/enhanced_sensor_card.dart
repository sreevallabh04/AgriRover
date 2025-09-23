import 'package:flutter/material.dart';
import '../models/enhanced_sensor_data.dart';

class EnhancedSensorCard extends StatefulWidget {
  final EnhancedSensorData sensor;
  final VoidCallback? onTap;

  const EnhancedSensorCard({
    super.key,
    required this.sensor,
    this.onTap,
  });

  @override
  State<EnhancedSensorCard> createState() => _EnhancedSensorCardState();
}

class _EnhancedSensorCardState extends State<EnhancedSensorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getSensorIcon(String type) {
    switch (type) {
      case 'Temperature':
        return Icons.thermostat;
      case 'Humidity':
        return Icons.water_drop;
      case 'Soil Moisture':
        return Icons.eco;
      case 'Air Quality':
        return Icons.air;
      default:
        return Icons.sensors;
    }
  }

  Color _getSensorColor(String type, bool isNormal) {
    if (!isNormal) return Colors.red.shade400;

    switch (type) {
      case 'Temperature':
        return Colors.orange.shade400;
      case 'Humidity':
        return Colors.blue.shade400;
      case 'Soil Moisture':
        return Colors.green.shade400;
      case 'Air Quality':
        return Colors.purple.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 98) return Colors.green;
    if (accuracy >= 95) return Colors.lightGreen;
    if (accuracy >= 90) return Colors.orange;
    if (accuracy >= 80) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final scale = width >= 1200
        ? 1.6
        : width >= 900
            ? 1.4
            : width >= 600
                ? 1.2
                : 1.0;
    final icon = _getSensorIcon(widget.sensor.type);
    final color = _getSensorColor(widget.sensor.type, widget.sensor.isNormal);
    final accuracyColor = _getAccuracyColor(widget.sensor.accuracy);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 8,
              shadowColor: color.withOpacity(0.3),
              child: Container(
                padding: EdgeInsets.all(6 * scale),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with icon and accuracy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2 * scale),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 12 * scale,
                          ),
                        ),
                        // Accuracy indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * scale,
                            vertical: 1 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: accuracyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 6 * scale,
                                color: accuracyColor,
                              ),
                              SizedBox(width: 1 * scale),
                              Text(
                                '${widget.sensor.accuracy.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: accuracyColor,
                                  fontSize: 5 * scale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3 * scale),

                    // Sensor type
                    Text(
                      widget.sensor.type,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 9 * scale,
                      ),
                    ),
                    SizedBox(height: 1 * scale),

                    // Value and unit
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            widget.sensor.value.toStringAsFixed(1),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 1 * scale),
                        Text(
                          widget.sensor.unit,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color.withOpacity(0.8),
                            fontSize: 9 * scale,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1 * scale),

                    // Status and improvement
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * scale,
                            vertical: 1 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: widget.sensor.isNormal
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            widget.sensor.isNormal ? 'Normal' : 'Alert',
                            style: TextStyle(
                              color: widget.sensor.isNormal
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 6 * scale,
                            ),
                          ),
                        ),

                        // Accuracy improvement
                        if (widget.sensor.accuracyImprovement > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2 * scale,
                              vertical: 1 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 5 * scale,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 1 * scale),
                                Text(
                                  '+${widget.sensor.accuracyImprovement.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 5 * scale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1 * scale),

                    // Last update time
                    Text(
                      _formatTimestamp(widget.sensor.timestamp),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 6 * scale,
                      ),
                    ),

                    // AI Analysis indicator
                    if (widget.sensor.aiAnalysis != null)
                      Container(
                        margin: EdgeInsets.only(top: 2 * scale),
                        padding: EdgeInsets.symmetric(
                          horizontal: 2 * scale,
                          vertical: 1 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 5 * scale,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 1 * scale),
                            Text(
                              'AI: ${widget.sensor.aiAnalysis!.confidenceText}',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 5 * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Live';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
