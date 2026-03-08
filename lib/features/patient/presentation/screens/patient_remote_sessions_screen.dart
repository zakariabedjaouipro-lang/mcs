import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/models/video_session_model.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientRemoteSessionsScreen extends StatefulWidget {
  const PatientRemoteSessionsScreen({super.key});

  @override
  State<PatientRemoteSessionsScreen> createState() =>
      _PatientRemoteSessionsScreenState();
}

class _PatientRemoteSessionsScreenState
    extends State<PatientRemoteSessionsScreen> {
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
          title: Text(context.translateSafe('remote_sessions')),
          bottom: TabBar(
            tabs: [
              Tab(text: context.translateSafe('upcoming')),
              Tab(text: context.translateSafe('past')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UpcomingSessionsTab(),
            _PastSessionsTab(),
          ],
        ),
      ),
    );
  }
}

class _UpcomingSessionsTab extends StatelessWidget {
  const _UpcomingSessionsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UpcomingRemoteSessionsLoaded) {
          if (state.sessions.isEmpty) {
            return _empty(context);
          }
          return _list(context, state.sessions);
        }

        if (state is PatientError) {
          return _error(context, state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _PastSessionsTab extends StatelessWidget {
  const _PastSessionsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PastRemoteSessionsLoaded) {
          if (state.sessions.isEmpty) {
            return _empty(context);
          }
          return _list(context, state.sessions);
        }

        if (state is PatientError) {
          return _error(context, state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

Widget _empty(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.video_call_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          context.translateSafe('no_sessions'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}

Widget _error(BuildContext context, String message) {
  return Center(child: Text(message));
}

Widget _list(BuildContext context, List<VideoSessionModel> sessions) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: sessions.length,
    itemBuilder: (context, index) {
      return _card(context, sessions[index]);
    },
  );
}

Widget _card(BuildContext context, VideoSessionModel session) {
  final date = session.sessionDate;

  if (date == null) {
    return const SizedBox.shrink();
  }

  final now = DateTime.now();
  final isUpcoming = date.isAfter(now);
  final canJoin = isUpcoming && date.difference(now).inMinutes <= 15;

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 6),

          /// Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(
                '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
              ),
              const SizedBox(width: 16),
              const Icon(Icons.timer, size: 16),
              const SizedBox(width: 4),
              Text('${session.duration} min'),
            ],
          ),

          const SizedBox(height: 6),

          /// Doctor
          Row(
            children: [
              const Icon(Icons.person, size: 16),
              const SizedBox(width: 4),
              Text(session.doctorName ?? 'Doctor'),
            ],
          ),

          if (session.notes != null) ...[
            const SizedBox(height: 8),
            Text(session.notes!),
          ],

          if (canJoin) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.video_call),
                label: Text(context.translateSafe('join_session')),
                onPressed: () {
                  _joinDialog(context, session);
                },
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

void _joinDialog(BuildContext context, VideoSessionModel session) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.translateSafe('join_session')),
        content: Text(context.translateSafe('confirm_join_session')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.translateSafe('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PatientBloc>().add(
                    JoinVideoSession(session.id),
                  );
            },
            child: Text(context.translateSafe('join')),
          ),
        ],
      );
    },
  );
}
