part of 'analysis_cubit.dart';

abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

// Fetch Analysis Records States
class AnalysisLoading extends AnalysisState {}

class AnalysisLoaded extends AnalysisState {
  final List<AnalysisRecord> records;
  final int pageIndex;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  AnalysisLoaded({
    required this.records,
    required this.pageIndex,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}

class AnalysisError extends AnalysisState {
  final String message;
   AnalysisError({required this.message});
}

// Upload Analysis States (Similar to Add Medicine states)
class AnalysisUploading extends AnalysisState {}

class AnalysisUploadSuccess extends AnalysisState {
  final String message;
  AnalysisUploadSuccess({required this.message});
}

class AnalysisUploadError extends AnalysisState {
  final String message;
   AnalysisUploadError({required this.message});
}

// Update Analysis States
class AnalysisUpdateLoading extends AnalysisState {}

class AnalysisUpdateSuccess extends AnalysisState {}

class AnalysisUpdateError extends AnalysisState {
  final String errorMessage;
   AnalysisUpdateError({required this.errorMessage});
}

// Delete Analysis States
class AnalysisDeleteLoading extends AnalysisState {}

class AnalysisDeleteSuccess extends AnalysisState {}

class AnalysisDeleteError extends AnalysisState {
  final String errorMessage;
   AnalysisDeleteError({required this.errorMessage});
}

// Search Analysis States
class SearchAnalysisLoading extends AnalysisState {}

class SearchAnalysisSuccess extends AnalysisState {
  final List<AnalysisRecord> records;
  SearchAnalysisSuccess(this.records);
}

class SearchAnalysisError extends AnalysisState {
  final String message;
   SearchAnalysisError(this.message);
}