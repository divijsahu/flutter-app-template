import 'package:flutter/material.dart';
import 'package:flutter_app_template/utils/constants.dart';
import 'package:flutter_app_template/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,

      // Theme configuration from theme.dart
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const TemplateHomePage(),
    );
  }
}

class TemplateHomePage extends StatelessWidget {
  const TemplateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App Template'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Icon
              Icon(
                Icons.rocket_launch,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Welcome Text
              Text(
                'Welcome to Flutter App Template!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'This is a clean starter template with:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Features list
              _buildFeatureCard(
                context,
                icon: Icons.architecture,
                title: 'Clean Architecture',
                description: 'Well-organized folder structure',
              ),
              const SizedBox(height: 12),

              _buildFeatureCard(
                context,
                icon: Icons.palette,
                title: 'Material 3 Theme',
                description: 'Beautiful, modern UI system',
              ),
              const SizedBox(height: 12),

              _buildFeatureCard(
                context,
                icon: Icons.api,
                title: 'API Integration',
                description: 'Ready-to-use API services',
              ),
              const SizedBox(height: 12),

              _buildFeatureCard(
                context,
                icon: Icons.image,
                title: 'Smart Image Management',
                description: 'Optimized image loading',
              ),

              const SizedBox(height: 32),

              // Get Started Button
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ready to customize! Check TEMPLATE_SETUP.md for instructions.',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Documentation Link
              TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to example page or documentation
                },
                icon: const Icon(Icons.book),
                label: const Text('View Documentation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(description),
      ),
    );
  }
}
