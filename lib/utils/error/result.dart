/// Result class for handling success/failure states
/// 
/// This class provides a type-safe way to handle operations that can succeed or fail.
/// It eliminates the need for null checks and provides clear error messages.
/// 
/// Usage:
/// ```dart
/// final result = await someAsyncOperation();
/// if (result.isSuccess) {
///   // Handle success
///   final data = result.data;
/// } else {
///   // Handle failure
///   final error = result.error;
/// }
/// ```
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data) : error = null, isSuccess = true;
  const Result.failure(this.error) : data = null, isSuccess = false;

  bool get isFailure => !isSuccess;
}
