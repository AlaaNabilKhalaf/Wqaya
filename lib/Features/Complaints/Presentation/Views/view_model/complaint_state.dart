// lib/Features/Complaints/Presentation/Views/view_model/complaint_state.dart

abstract class ComplaintState {}

class ComplaintInitial extends ComplaintState {}

// Loading States
class UserComplaintsLoading extends ComplaintState {}
class AddComplaintLoading extends ComplaintState {}
class DeleteComplaintLoading extends ComplaintState {}
class SearchComplaintsLoading extends ComplaintState {}

// Success States
class UserComplaintsLoaded extends ComplaintState {
  final List<dynamic> complaints;

  UserComplaintsLoaded(this.complaints);
}

class AddComplaintSuccess extends ComplaintState {
  final String message;

  AddComplaintSuccess(this.message);
}

class DeleteComplaintSuccess extends ComplaintState {
  final String message;

  DeleteComplaintSuccess(this.message);
}

class SearchComplaintsSuccess extends ComplaintState {
  final List<dynamic> complaints;

  SearchComplaintsSuccess(this.complaints);
}

// Error States
class UserComplaintsError extends ComplaintState {
  final String message;

  UserComplaintsError(this.message);
}

class AddComplaintError extends ComplaintState {
  final String message;

  AddComplaintError(this.message);
}

class DeleteComplaintError extends ComplaintState {
  final String message;

  DeleteComplaintError(this.message);
}

class SearchComplaintsError extends ComplaintState {
  final String message;

  SearchComplaintsError(this.message);
}