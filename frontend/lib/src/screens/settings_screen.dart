import 'package:flutter/material.dart';
import '../constants/app_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDark = false;
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(AppIcons.theme),
                const SizedBox(width: 12),
                const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            Switch(
              value: isDark,
              onChanged: (v) => setState(() => isDark = v),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text('API Key', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _apiKeyController,
          decoration: const InputDecoration(
            prefixIcon: Icon(AppIcons.api),
            border: OutlineInputBorder(),
            hintText: 'Enter your API key',
          ),
        ),
        const SizedBox(height: 32),
        const Divider(),
        ListTile(
          leading: const Icon(AppIcons.info),
          title: const Text('Version 1.0.0'),
          subtitle: const Text('Privacy Policy'),
          onTap: () {},
        ),
      ],
    );
  }
} 