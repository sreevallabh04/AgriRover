import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/rover_provider.dart';
import '../widgets/animated_button.dart';

class ManualControlScreen extends StatefulWidget {
  const ManualControlScreen({super.key});

  @override
  State<ManualControlScreen> createState() => _ManualControlScreenState();
}

class _ManualControlScreenState extends State<ManualControlScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _movementController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _movementController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _movementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roverProvider = Provider.of<RoverProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Control'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: roverProvider.status.isPowered ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              roverProvider.status.isPowered ? 'CONNECTED' : 'DISCONNECTED',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildStatusBar(roverProvider),
                          const SizedBox(height: 24),
                          Expanded(
                            child: _buildControlPad(roverProvider),
                          ),
                          const SizedBox(height: 24),
                          _buildActionButtons(roverProvider),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomPanel(roverProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBar(RoverProvider roverProvider) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.1),
            theme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusItem(
              'Speed',
              '2.5 km/h',
              Icons.speed,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.primaryColor.withOpacity(0.2),
          ),
          Expanded(
            child: _buildStatusItem(
              'Battery',
              '${roverProvider.status.batteryLevel.toInt()}%',
              Icons.battery_charging_full,
              _getBatteryColor(roverProvider.status.batteryLevel),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.primaryColor.withOpacity(0.2),
          ),
          Expanded(
            child: _buildStatusItem(
              'Mode',
              roverProvider.status.mode.name.toUpperCase(),
              Icons.settings,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
      String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildControlPad(RoverProvider roverProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Forward button
          _buildDirectionButton(
            'Forward',
            Icons.keyboard_arrow_up,
            () => _sendCommand('forward', roverProvider),
            Colors.green,
            isDisabled: !roverProvider.status.isPowered,
          ),
          const SizedBox(height: 20),

          // Left and Right buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDirectionButton(
                'Left',
                Icons.keyboard_arrow_left,
                () => _sendCommand('left', roverProvider),
                Colors.orange,
                isDisabled: !roverProvider.status.isPowered,
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/robot.json',
                    width: 40,
                    height: 40,
                    repeat: roverProvider.status.isPowered,
                    animate: roverProvider.status.isPowered,
                  ),
                ),
              ),
              _buildDirectionButton(
                'Right',
                Icons.keyboard_arrow_right,
                () => _sendCommand('right', roverProvider),
                Colors.orange,
                isDisabled: !roverProvider.status.isPowered,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Backward button
          _buildDirectionButton(
            'Backward',
            Icons.keyboard_arrow_down,
            () => _sendCommand('backward', roverProvider),
            Colors.red,
            isDisabled: !roverProvider.status.isPowered,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(
      String label, IconData icon, VoidCallback onPressed, Color color,
      {bool isDisabled = false}) {
    return Column(
      children: [
        GestureDetector(
          onTap: isDisabled ? null : onPressed,
          onTapDown: isDisabled ? null : (_) => _movementController.forward(),
          onTapUp: isDisabled ? null : (_) => _movementController.reverse(),
          onTapCancel: isDisabled ? null : () => _movementController.reverse(),
          child: AnimatedBuilder(
            animation: _movementController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_movementController.value * 0.1),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? Colors.grey.shade300
                        : color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDisabled ? Colors.grey.shade400 : color,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDisabled
                            ? Colors.transparent
                            : color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: isDisabled ? Colors.grey.shade600 : color,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDisabled ? Colors.grey.shade600 : color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(RoverProvider roverProvider) {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            text: 'Emergency Stop',
            icon: Icons.stop,
            color: Colors.red,
            onPressed: roverProvider.status.isPowered
                ? () => _sendCommand('stop', roverProvider)
                : null,
            isLoading: roverProvider.isProcessing,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedButton(
            text: 'Return Home',
            icon: Icons.home,
            color: Colors.blue,
            onPressed: roverProvider.status.isPowered
                ? () => _sendCommand('home', roverProvider)
                : null,
            isLoading: roverProvider.isProcessing,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPanel(RoverProvider roverProvider) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlOption(
                'Speed +',
                Icons.add,
                () => _sendCommand('speed_up', roverProvider),
                Colors.green,
              ),
              _buildControlOption(
                'Speed -',
                Icons.remove,
                () => _sendCommand('speed_down', roverProvider),
                Colors.red,
              ),
              _buildControlOption(
                'Rotate L',
                Icons.rotate_left,
                () => _sendCommand('rotate_left', roverProvider),
                Colors.orange,
              ),
              _buildControlOption(
                'Rotate R',
                Icons.rotate_right,
                () => _sendCommand('rotate_right', roverProvider),
                Colors.orange,
              ),
            ],
          ),
          if (!roverProvider.status.isPowered) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rover is powered off. Please turn on the rover to use manual controls.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlOption(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(double level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  void _sendCommand(String command, RoverProvider roverProvider) {
    if (!roverProvider.status.isPowered) return;

    roverProvider.sendCommand(command);

    // Show feedback
    String message;
    switch (command) {
      case 'forward':
        message = 'Moving forward';
        break;
      case 'backward':
        message = 'Moving backward';
        break;
      case 'left':
        message = 'Turning left';
        break;
      case 'right':
        message = 'Turning right';
        break;
      case 'stop':
        message = 'Emergency stop activated';
        break;
      case 'home':
        message = 'Returning to home position';
        break;
      case 'speed_up':
        message = 'Increasing speed';
        break;
      case 'speed_down':
        message = 'Decreasing speed';
        break;
      case 'rotate_left':
        message = 'Rotating left';
        break;
      case 'rotate_right':
        message = 'Rotating right';
        break;
      default:
        message = 'Command sent';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
