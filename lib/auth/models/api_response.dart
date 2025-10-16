import 'package:equatable/equatable.dart';

// Generic API Response wrapper
class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final ApiError? error;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }

  // Success response
  factory ApiResponse.success({
    required String message,
    T? data,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
    );
  }

  // Error response
  factory ApiResponse.error({
    required String message,
    ApiError? error,
    String? errorDetails,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      error: error ?? (errorDetails != null ? ApiError(code: 'ERROR', message: errorDetails) : null),
    );
  }

  @override
  List<Object?> get props => [success, message, data, error];
}

// API Error model
class ApiError extends Equatable {
  final String code;
  final String message;
  final String? details;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
    );
  }

  @override
  List<Object?> get props => [code, message, details];
}

// Validation Error model
class ValidationError extends Equatable {
  final String field;
  final String message;

  const ValidationError({
    required this.field,
    required this.message,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );
  }

  @override
  List<Object?> get props => [field, message];
}

// Validation Error Response
class ValidationErrorResponse extends Equatable {
  final List<ValidationError> errors;

  const ValidationErrorResponse({
    required this.errors,
  });

  factory ValidationErrorResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> errorsList = json['errors'] as List<dynamic>? ?? [];
    return ValidationErrorResponse(
      errors: errorsList
          .map((error) => ValidationError.fromJson(error as Map<String, dynamic>))
          .toList(),
    );
  }

  String get firstError => errors.isNotEmpty ? errors.first.message : 'Validation failed';
  
  String getFieldError(String field) {
    final error = errors.firstWhere(
      (e) => e.field == field,
      orElse: () => const ValidationError(field: '', message: ''),
    );
    return error.message;
  }

  @override
  List<Object?> get props => [errors];
}
