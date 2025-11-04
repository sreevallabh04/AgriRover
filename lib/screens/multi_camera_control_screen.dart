import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/cameras_provider.dart';
import '../providers/location_provider.dart';

class MultiCameraControlScreen extends StatefulWidget {
  const MultiCameraControlScreen({super.key});

  @override
  State<MultiCameraControlScreen> createState() =>
      _MultiCameraControlScreenState();
}

class _MultiCameraControlScreenState extends State<MultiCameraControlScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Ensure location initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cams = context.watch<CamerasProvider>().cameras;
    final loc = context.watch<LocationProvider>().currentPosition;

    final center = loc != null
        ? LatLng(loc.latitude, loc.longitude)
        : LatLng(cams.first.latitude, cams.first.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Camera Control'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            // Map section
            SizedBox(
              height: 260,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.agri_rover',
                  ),
                  MarkerLayer(
                    markers: [
                      if (loc != null)
                        Marker(
                          point: LatLng(loc.latitude, loc.longitude),
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.my_location,
                                color: Colors.blue),
                          ),
                        ),
                      ...cams.map((c) => Marker(
                            point: LatLng(c.latitude, c.longitude),
                            width: 44,
                            height: 44,
                            child: Tooltip(
                              message: c.name,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.videocam,
                                    color: Colors.green),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),

            // Cameras grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: cams.length,
                  itemBuilder: (context, index) {
                    final cam = cams[index];
                    return _CameraTile(cameraId: cam.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraTile extends StatelessWidget {
  final String cameraId;
  const _CameraTile({required this.cameraId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CamerasProvider>();
    final cam = provider.cameras.firstWhere((c) => c.id == cameraId);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.smart_toy, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cam.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Icon(Icons.videocam, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cam.isRecording ? 'Recording' : 'Idle',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cam.isRecording ? Colors.red : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        cam.isRecording
                            ? Icons.stop
                            : Icons.fiber_manual_record,
                        color:
                            cam.isRecording ? Colors.red : theme.primaryColor,
                      ),
                      onPressed: () => provider.toggleRecording(cam.id),
                      tooltip: cam.isRecording ? 'Stop' : 'Record',
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on, color: Colors.blue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Location: ${cam.latitude.toStringAsFixed(5)}, ${cam.longitude.toStringAsFixed(5)}',
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      tooltip: 'Show coordinates',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
