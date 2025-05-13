part of 'analysis_cubit.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisUploading extends AnalysisState {}

class AnalysisLoaded extends AnalysisState {
  final List<AnalysisRecord> records;
  final int pageIndex;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const AnalysisLoaded({
    required this.records,
    required this.pageIndex,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
    records,
    pageIndex,
    totalPages,
    totalCount,
    hasPreviousPage,
    hasNextPage
  ];
}

class AnalysisUploadSuccess extends AnalysisState {
  final String message;

  const AnalysisUploadSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError({required this.message});

  @override
  List<Object?> get props => [message];
}
class AnalysisUploadError extends AnalysisState {
  final String message;

  const AnalysisUploadError({required this.message});

  @override
  List<Object?> get props => [message];
}
// Success state for analysis update
class AnalysisUpdateSuccess extends AnalysisState {}
class AnalysisUpdateError extends AnalysisState {
  final String message;

  const AnalysisUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}
class AnalysisDeleting extends AnalysisState {}
class AnalysisDeleteSuccess extends AnalysisState {}
class AnalysisDeleteError extends AnalysisState {
  final String message;

  const AnalysisDeleteError({required this.message});

  @override
  List<Object?> get props => [message];
}

