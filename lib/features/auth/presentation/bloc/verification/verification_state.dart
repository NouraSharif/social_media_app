import 'package:equatable/equatable.dart';

sealed class VerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class VerificationInitial extends VerificationState {}

final class VerificationLoading extends VerificationState {}

final class VerificationSuccess extends VerificationState {}

final class VerificationFailure extends VerificationState {
  final String message;

  VerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
