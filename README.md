# AgriRover - Smart Agriculture Mobile Application

A Flutter-based mobile application for smart agriculture management with real-time sensor monitoring, rover control, and irrigation management.

## Features

### 🎯 Core Functionality
- **Real-time Sensor Data Visualization**: Temperature, humidity, soil moisture, and air quality monitoring
- **Camera Feed Integration**: Live crop imaging with ESP32-CAM support
- **Rover Power Control**: Toggle ON/OFF state of the rover directly from the app
- **Manual Rover Override**: Bluetooth RC control with directional movement
- **Irrigation Control**: Water pump management with scheduling
- **Alert System**: Notifications for abnormal readings and system issues

### 🎨 UI/UX Features
- **Smooth Animations**: Lottie animations for enhanced user experience
- **Modern Design**: Material 3 design system with custom theming
- **Dark/Light Mode**: Theme switching with persistent preferences
- **Responsive Layout**: Optimized for various screen sizes
- **Interactive Charts**: Real-time data visualization with Syncfusion charts

### 📱 Screens
1. **Dashboard**: Main overview with sensor cards and system status
2. **Camera Feed**: Live camera feed with recording and capture capabilities
3. **Rover Control**: Power management and mode selection
4. **Manual Control**: Directional controls with Lottie-based movement effects
5. **Irrigation Control**: Water pump management and statistics
6. **Alerts**: Notification center with priority-based alerts
7. **Settings**: Theme toggle, connectivity status, and system information

## Architecture

### State Management
- **Provider Pattern**: For global state management
- **ChangeNotifier**: Reactive state updates
- **Mock Data**: Simulated sensor data and system responses

### Project Structure
```
lib/
├── models/           # Data models and entities
├── providers/        # State management providers
├── screens/          # UI screens
├── widgets/          # Reusable UI components
├── theme/            # App theming and colors
└── main.dart         # Application entry point
```

## Dependencies

### Core Flutter
- `flutter`: SDK
- `provider`: State management
- `flutter_bloc`: Alternative state management (available)

### UI & Animations
- `lottie`: Smooth animations
- `syncfusion_flutter_charts`: Data visualization
- `cached_network_image`: Image caching

### Functionality
- `connectivity_plus`: Network status monitoring
- `flutter_local_notifications`: Local notifications
- `intl`: Internationalization and date formatting

## Installation

1. **Prerequisites**
   ```bash
   flutter --version  # Ensure Flutter 3.0.0+ is installed
   ```

2. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd AgriRover
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

## Usage

### Dashboard
- View real-time sensor data in animated cards
- Monitor system status (rover power, irrigation, battery, alerts)
- Access quick actions for common tasks
- Pull to refresh for updated data

### Rover Control
- Toggle rover power with animated switch
- Select operation mode (Manual/Automatic/Maintenance)
- Monitor battery level and position
- View connection status

### Manual Control
- Use directional buttons for rover movement
- Emergency stop and return home functions
- Speed control and rotation options
- Visual feedback with Lottie animations

### Irrigation Management
- Start/stop irrigation with toggle switch
- View water usage statistics and efficiency
- Schedule management and last irrigation tracking
- Quick actions for testing and maintenance

### Camera Feed
- Live camera feed from ESP32-CAM
- Image capture and video recording
- Zoom controls and flash toggle
- Connection status monitoring

### Alerts & Notifications
- Priority-based alert system
- Mark as read and resolve functionality
- Alert filtering and management
- Test alert creation

### Settings
- Dark/Light theme toggle
- Connectivity status management
- System information and data management
- Notification preferences

## Mock Data

The application uses mock data to simulate real sensor readings and system responses:

- **Sensor Data**: Temperature (15-35°C), Humidity (40-80%), Soil Moisture (30-70%), Air Quality (0-100 AQI)
- **Rover Status**: Battery levels, connection status, position tracking
- **Irrigation Data**: Water usage, efficiency metrics, scheduling
- **Alerts**: System warnings, maintenance reminders, status updates

## Customization

### Theming
- Modify `lib/theme/app_theme.dart` for color schemes
- Update Material 3 color tokens for consistent theming
- Add custom animations in Lottie format

### Mock Data
- Update providers in `lib/providers/` for different data patterns
- Modify sensor ranges and alert thresholds
- Customize rover behavior and irrigation schedules

### UI Components
- Extend widgets in `lib/widgets/` for custom functionality
- Add new screens in `lib/screens/`
- Implement additional animations and transitions

## Future Enhancements

- **Real Device Integration**: Connect to actual Arduino/ESP32 hardware
- **Cloud Integration**: MQTT/ThingSpeak/AWS IoT connectivity
- **Machine Learning**: TensorFlow Lite integration for crop analysis
- **Data Persistence**: Local database for historical data
- **Advanced Analytics**: Trend analysis and predictive insights
- **Multi-language Support**: Internationalization expansion
- **Offline Mode**: Enhanced offline functionality

## Development Notes

- All UI components are fully functional with mock data
- Animations and transitions are optimized for smooth performance
- State management follows Flutter best practices
- Code is organized for easy maintenance and extension
- No backend dependencies - completely standalone application

## License

This project is developed for educational and demonstration purposes.

## Support

For questions or issues, please refer to the Flutter documentation or create an issue in the repository.
