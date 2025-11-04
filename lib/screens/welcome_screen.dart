import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int _currentPage = 0;

  final List<WelcomePage> _pages = [
    WelcomePage(
      title: "Welcome to AgriRover",
      subtitle: "Smart Agriculture at Your Fingertips",
      description:
          "Monitor your crops, control irrigation, and optimize your farm with AI-powered insights.",
      icon: Icons.agriculture,
      color: Colors.green,
    ),
    WelcomePage(
      title: "Real-Time Monitoring",
      subtitle: "Live Sensor Data",
      description:
          "Get instant updates on temperature, humidity, soil moisture, and air quality with 99.2% accuracy.",
      icon: Icons.sensors,
      color: Colors.blue,
    ),
    WelcomePage(
      title: "AI-Powered Analysis",
      subtitle: "Smart Recommendations",
      description:
          "Our AI analyzes your data to provide actionable insights for better crop management.",
      icon: Icons.psychology,
      color: Colors.purple,
    ),
    WelcomePage(
      title: "Automated Control",
      subtitle: "Rover & Irrigation",
      description:
          "Control your agricultural rover and irrigation systems remotely with precision.",
      icon: Icons.smart_toy,
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _pageController = PageController();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    // Scale down vertical dimensions on short screens to avoid overflow
    final scale = height >= 900
        ? 1.15
        : height >= 700
            ? 1.0
            : height >= 600
                ? 0.9
                : 0.8;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
              Colors.green.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildBottomSection(scale),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(WelcomePage page) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;
                final localScale = h >= 700
                    ? 1.0
                    : h >= 600
                        ? 0.9
                        : 0.8;
                return Padding(
                  padding: EdgeInsets.all(32.0 * localScale),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon
                      Container(
                        width: 120 * localScale,
                        height: 120 * localScale,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(60 * localScale),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20 * localScale,
                              offset: Offset(0, 10 * localScale),
                            ),
                          ],
                        ),
                        child: Icon(
                          page.icon,
                          size: 60 * localScale,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40 * localScale),

                      // Title
                      Text(
                        page.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16 * localScale),

                      // Subtitle
                      Text(
                        page.subtitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24 * localScale),

                      // Description
                      Text(
                        page.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(double scale) {
    final buttonHeight = (56 * scale).clamp(44.0, 56.0);
    final outerPadding = EdgeInsets.all((32.0 * scale).clamp(16.0, 32.0));
    final indicatorActiveWidth = (24 * scale).clamp(16.0, 24.0);
    final indicatorHeight = (8 * scale).clamp(6.0, 8.0);

    return Padding(
      padding: outerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index
                    ? indicatorActiveWidth
                    : indicatorHeight,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(indicatorHeight / 2),
                ),
              ),
            ),
          ),
          SizedBox(height: (32 * scale).clamp(16.0, 32.0)),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular((28 * scale).clamp(20.0, 28.0)),
                ),
                elevation: 8,
              ),
              child: Text(
                _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: (16 * scale).clamp(8.0, 16.0)),

          // Skip Button
          TextButton(
            onPressed: _navigateToDashboard,
            child: Text(
              "Skip",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  WelcomePage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
