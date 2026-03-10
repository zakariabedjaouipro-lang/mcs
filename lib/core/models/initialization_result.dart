/// Models for application initialization flow.
///
/// Tracks the result of each initialization phase with
/// timing, error details, and recovery information.
library;

import 'package:equatable/equatable.dart';

/// Initialization phase identifier.
enum InitializationPhase {
  appConfig,
  networkCheck,
  supabaseInit,
  dependencyInjection,
  appLaunch,
}

/// Result of an initialization phase.
class PhaseResult extends Equatable {
  const PhaseResult({
    required this.phase,
    required this.success,
    required this.durationMs,
    this.error,
    this.stackTrace,
  });

  /// The initialization phase.
  final InitializationPhase phase;

  /// Whether the phase succeeded.
  final bool success;

  /// Duration in milliseconds.
  final int durationMs;

  /// Error if phase failed.
  final String? error;

  /// Stack trace if available.
  final String? stackTrace;

  /// Human-readable phase name.
  String get phaseName {
    switch (phase) {
      case InitializationPhase.appConfig:
        return 'App Configuration';
      case InitializationPhase.networkCheck:
        return 'Network Connectivity Check';
      case InitializationPhase.supabaseInit:
        return 'Supabase Initialization';
      case InitializationPhase.dependencyInjection:
        return 'Dependency Injection';
      case InitializationPhase.appLaunch:
        return 'App Launch';
    }
  }

  /// Status emoji.
  String get statusEmoji => success ? '✅' : '❌';

  /// Formatted log message.
  String toLogMessage() =>
      '$statusEmoji $phaseName: ${durationMs}ms${error != null ? ' - $error' : ''}';

  @override
  List<Object?> get props => [phase, success, durationMs, error, stackTrace];
}

/// Overall initialization result.
class InitializationResult extends Equatable {
  const InitializationResult({
    required this.success,
    required this.phases,
    required this.totalDurationMs,
  });

  /// Whether initialization succeeded overall.
  final bool success;

  /// Results of each phase.
  final List<PhaseResult> phases;

  /// Total time in milliseconds.
  final int totalDurationMs;

  /// First failed phase, if any.
  PhaseResult? get failedPhase =>
      phases.firstWhere((p) => !p.success, orElse: () => const PhaseResult(phase: InitializationPhase.appLaunch, success: false, durationMs: 0));

  /// Complete diagnostics report.
  String toDiagnosticsReport() {
    final lines = <String>[
      '═══════════════════════════════════════════════════════',
      'APPLICATION INITIALIZATION REPORT',
      '═══════════════════════════════════════════════════════',
      '',
      'Overall Status: ${success ? '✅ SUCCESS' : '❌ FAILED'}',
      'Total Time: ${totalDurationMs}ms',
      '',
      'Phase Results:',
      ...phases.map((p) => '  ${p.toLogMessage()}'),
      '',
      if (!success) ...[
        'Failed Phase: ${failedPhase?.phaseName}',
        'Error: ${failedPhase?.error}',
      ],
      '═══════════════════════════════════════════════════════',
    ];
    return lines.join('\n');
  }

  @override
  List<Object?> get props => [success, phases, totalDurationMs];
}
