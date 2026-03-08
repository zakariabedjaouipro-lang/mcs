/// Patient Remote Sessions Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient remote sessions screen
class PatientRemoteSessionsScreen extends StatefulWidget {
  const PatientRemoteSessionsScreen({super.key});

  @override
  State<PatientRemoteSessionsScreen> createState() => _PatientRemoteSessionsScreenState();
}

class _PatientRemoteSessionsScreenState extends State<PatientRemoteSessionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadUpcomingRemoteSessions());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('remote_sessions')),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context).translate('upcoming')),
              Tab(text: AppLocalizations.of(context).translate('past')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpcomingSessions(),
            _buildPastSessions(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpcomingRemoteSessionsLoaded) {
          if (state.sessions.isEmpty) {
            return _buildEmptyState(context, AppLocalizations.of(context).translate('no_upcoming_sessions'));
          }
          return _buildSessionsList(state.sessions);
        } else if (state is PatientError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPastSessions() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PastRemoteSessionsLoaded) {
          if (state.sessions.isEmpty) {
            return _buildEmptyState(context, AppLocalizations.of(context).translate('no_past_sessions'));
          }
          return _buildSessionsList(state.sessions);
        } else if (state is PatientError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_call_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(List<VideoSessionModel> sessions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(VideoSessionModel session) {
    final isUpcoming = session.sessionDate.isAfter(DateTime.now());
    final canJoin = isUpcoming && 
        session.sessionDate.difference(DateTime.now()).inMinutes <= 15;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${session.sessionDate.day}/${session.sessionDate.month}/${session.sessionDate.year}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: session.status == VideoSessionStatus.scheduled
                        ? Colors.blue.withAlphaSafe(0.1)
                        : Colors.green.withAlphaSafe(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.status.dbValue.toUpperCase(),
                    style: TextStyle(
                      color: session.status == VideoSessionStatus.scheduled ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${session.sessionDate.hour}:${session.sessionDate.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${session.duration} min',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text(
                  session.doctorName ?? 'Doctor Name',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (canJoin) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showJoinDialog(session);
                  },
                  icon: const Icon(Icons.video_call),
                  label: Text(AppLocalizations.of(context).translate('join_session')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ] else if (isUpcoming) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlphaSafe(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).translate('session_available_soon'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(VideoSessionModel session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('join_video_session')),
        content: Text(
          AppLocalizations.of(context).translate('join_session_confirmation'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(JoinVideoSession(session.id));
            },
            child: Text(AppLocalizations.of(context).translate('join')),
          ),
        ],
      ),
    );
  }
}