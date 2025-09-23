import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/rover_provider.dart';
import '../models/rover_status.dart';
import '../widgets/animated_switch.dart';
import '../widgets/animated_button.dart';

class RoverControlScreen extends StatefulWidget {
  const RoverControlScreen({super.key});

  @override
  State<RoverControlScreen> createState() => _RoverControlScreenState();
}

class _RoverControlScreenState extends State<RoverControlScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roverProvider = Provider.of<RoverProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rover Control'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoverStatusCard(roverProvider),
                    const SizedBox(height: 24),
                    _buildPowerControlSection(roverProvider),
                    const SizedBox(height: 24),
                    _buildModeSelectionSection(roverProvider),
                    const SizedBox(height: 24),
                    _buildBatterySection(roverProvider),
                    const SizedBox(height: 24),
                    _buildPositionSection(roverProvider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoverStatusCard(RoverProvider roverProvider) {
    final theme = Theme.of(context);
    final status = roverProvider.status;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            status.isPowered ? Colors.green.shade400 : Colors.grey.shade400,
            status.isPowered ? Colors.green.shade600 : Colors.grey.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (status.isPowered ? Colors.green : Colors.grey)
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AgriRover Status',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status.isPowered ? 'POWERED ON' : 'POWERED OFF',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Lottie.asset(
                  'assets/animations/robot.json',
                  width: 60,
                  height: 60,
                  repeat: status.isPowered,
                  animate: status.isPowered,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  'Battery',
                  '${status.batteryLevel.toInt()}%',
                  Icons.battery_charging_full,
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'Mode',
                  status.mode.name.toUpperCase(),
                  Icons.settings,
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'Position',
                  status.position,
                  Icons.location_on,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerControlSection(RoverProvider roverProvider) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Power Control',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rover Power',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roverProvider.status.isPowered
                          ? 'Rover is currently powered on'
                          : 'Rover is currently powered off',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (roverProvider.isProcessing)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                AnimatedSwitch(
                  value: roverProvider.status.isPowered,
                  onChanged: (value) {
                    roverProvider.togglePower();
                  },
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey.shade400,
                ),
            ],
          ),
          if (roverProvider.status.isPowered) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rover is ready for operation',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
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

  Widget _buildModeSelectionSection(RoverProvider roverProvider) {
    final theme = Theme.of(context);
    final currentMode = roverProvider.status.mode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operation Mode',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  'Manual',
                  Icons.gamepad,
                  RoverMode.manual,
                  currentMode,
                  Colors.blue,
                  roverProvider.setMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  'Automatic',
                  Icons.auto_mode,
                  RoverMode.automatic,
                  currentMode,
                  Colors.green,
                  roverProvider.setMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  'Maintenance',
                  Icons.build,
                  RoverMode.maintenance,
                  currentMode,
                  Colors.orange,
                  roverProvider.setMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(
    String label,
    IconData icon,
    RoverMode mode,
    RoverMode currentMode,
    Color color,
    Function(RoverMode) onTap,
  ) {
    final theme = Theme.of(context);
    final isSelected = currentMode == mode;

    return GestureDetector(
      onTap: () => onTap(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatterySection(RoverProvider roverProvider) {
    final theme = Theme.of(context);
    final batteryLevel = roverProvider.status.batteryLevel;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Battery Status',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _getBatteryIcon(batteryLevel),
                color: _getBatteryColor(batteryLevel),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: batteryLevel / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor:
                AlwaysStoppedAnimation<Color>(_getBatteryColor(batteryLevel)),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${batteryLevel.toInt()}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getBatteryColor(batteryLevel),
                ),
              ),
              Text(
                _getBatteryStatus(batteryLevel),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _getBatteryColor(batteryLevel),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSection(RoverProvider roverProvider) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Position',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  roverProvider.status.position,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AnimatedButton(
                text: 'Update',
                onPressed: () {
                  _updatePosition(roverProvider);
                },
                width: 80,
                height: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getBatteryIcon(double level) {
    if (level > 75) return Icons.battery_full;
    if (level > 50) return Icons.battery_6_bar;
    if (level > 25) return Icons.battery_4_bar;
    if (level > 10) return Icons.battery_2_bar;
    return Icons.battery_0_bar;
  }

  Color _getBatteryColor(double level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  String _getBatteryStatus(double level) {
    if (level > 75) return 'Excellent';
    if (level > 50) return 'Good';
    if (level > 25) return 'Low';
    if (level > 10) return 'Critical';
    return 'Empty';
  }

  void _updatePosition(RoverProvider roverProvider) {
    final positions = [
      'Field A',
      'Field B',
      'Field C',
      'Greenhouse',
      'Storage'
    ];
    final randomPosition =
        positions[DateTime.now().millisecond % positions.length];
    roverProvider.updatePosition(randomPosition);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Position updated to $randomPosition'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
