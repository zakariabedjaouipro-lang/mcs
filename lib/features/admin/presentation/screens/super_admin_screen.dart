import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Super Admin Dashboard Screen
class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('super_admin')),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Super Admin Dashboard - Coming Soon'),
      ),
    );
  }
}
