import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/models/user_approval_model.dart';
import 'package:mcs/core/usecases/approval_usecase.dart';
import 'package:mcs/core/usecases/usecase.dart';

/// Events for ApprovalBloc
/// الأحداث لـ ApprovalBloc
abstract class ApprovalEvent extends Equatable {
  const ApprovalEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch pending approvals
class FetchPendingApprovalsEvent extends ApprovalEvent {
  const FetchPendingApprovalsEvent();
}

/// Approve a user
class ApproveUserEvent extends ApprovalEvent {
  const ApproveUserEvent({
    required this.userId,
    this.approvalNotes,
  });

  final String userId;
  final String? approvalNotes;

  @override
  List<Object?> get props => [userId, approvalNotes];
}

/// Reject a user
class RejectUserEvent extends ApprovalEvent {
  const RejectUserEvent({
    required this.userId,
    required this.rejectionReason,
  });

  final String userId;
  final String rejectionReason;

  @override
  List<Object?> get props => [userId, rejectionReason];
}

/// Fetch approvals by status
class FetchApprovalsByStatusEvent extends ApprovalEvent {
  const FetchApprovalsByStatusEvent(this.status);

  final ApprovalStatus status;

  @override
  List<Object?> get props => [status];
}

/// Fetch approvals by role
class FetchApprovalsByRoleEvent extends ApprovalEvent {
  const FetchApprovalsByRoleEvent(this.role);

  final String role;

  @override
  List<Object?> get props => [role];
}

/// States for ApprovalBloc
/// الحالات لـ ApprovalBloc
abstract class ApprovalState extends Equatable {
  const ApprovalState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ApprovalInitial extends ApprovalState {
  const ApprovalInitial();
}

/// Loading state
class ApprovalLoading extends ApprovalState {
  const ApprovalLoading();
}

/// Successfully fetched approvals
class ApprovalsLoaded extends ApprovalState {
  const ApprovalsLoaded(this.approvals);

  final List<UserApprovalModel> approvals;

  @override
  List<Object?> get props => [approvals];
}

/// Successfully approved user
class UserApproved extends ApprovalState {
  const UserApproved(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Successfully rejected user
class UserRejected extends ApprovalState {
  const UserRejected(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Error state
class ApprovalError extends ApprovalState {
  const ApprovalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// BLoC for managing approvals
/// BLoC لإدارة الموافقات
class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  ApprovalBloc({
    required this.getPendingApprovalsUseCase,
    required this.approveUserUseCase,
    required this.rejectUserUseCase,
  }) : super(const ApprovalInitial()) {
    on<FetchPendingApprovalsEvent>(_onFetchPendingApprovals);
    on<ApproveUserEvent>(_onApproveUser);
    on<RejectUserEvent>(_onRejectUser);
    on<FetchApprovalsByStatusEvent>(_onFetchApprovalsByStatus);
    on<FetchApprovalsByRoleEvent>(_onFetchApprovalsByRole);
  }

  final GetPendingApprovalsUseCase getPendingApprovalsUseCase;
  final ApproveUserUseCase approveUserUseCase;
  final RejectUserUseCase rejectUserUseCase;

  /// Handle fetch pending approvals event
  Future<void> _onFetchPendingApprovals(
    FetchPendingApprovalsEvent event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    final result = await getPendingApprovalsUseCase(NoParams());

    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (approvals) => emit(ApprovalsLoaded(approvals)),
    );
  }

  /// Handle approve user event
  Future<void> _onApproveUser(
    ApproveUserEvent event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    final result = await approveUserUseCase(
      ApproveUserParams(
        userId: event.userId,
        approvalNotes: event.approvalNotes,
      ),
    );

    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (_) => emit(UserApproved(event.userId)),
    );
  }

  /// Handle reject user event
  Future<void> _onRejectUser(
    RejectUserEvent event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    final result = await rejectUserUseCase(
      RejectUserParams(
        userId: event.userId,
        rejectionReason: event.rejectionReason,
      ),
    );

    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (_) => emit(UserRejected(event.userId)),
    );
  }

  /// Handle fetch approvals by status event
  Future<void> _onFetchApprovalsByStatus(
    FetchApprovalsByStatusEvent event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    // This would require a specific use case
    // For now, we'll fetch all pending approvals
    final result = await getPendingApprovalsUseCase(NoParams());

    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (approvals) {
        final filtered = approvals
            .where((approval) => approval.status == event.status)
            .toList();
        emit(ApprovalsLoaded(filtered));
      },
    );
  }

  /// Handle fetch approvals by role event
  Future<void> _onFetchApprovalsByRole(
    FetchApprovalsByRoleEvent event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(const ApprovalLoading());

    // This would require a specific use case
    // For now, we'll fetch all pending approvals
    final result = await getPendingApprovalsUseCase(NoParams());

    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (approvals) {
        final filtered =
            approvals.where((approval) => approval.role == event.role).toList();
        emit(ApprovalsLoaded(filtered));
      },
    );
  }
}
