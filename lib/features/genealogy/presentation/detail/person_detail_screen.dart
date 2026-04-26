import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

// Placeholder — implémenté en phase A3
class PersonDetailScreen extends ConsumerWidget {
  const PersonDetailScreen({super.key, required this.memberId});
  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        backgroundColor: context.colors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.ink),
          onPressed: context.pop,
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
