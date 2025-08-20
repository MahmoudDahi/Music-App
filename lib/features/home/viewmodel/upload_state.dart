class UploadState {
  final bool isLoading;
  final double progress;
  final String? data;
  final String? error;

  const UploadState({
    this.isLoading = false,
    this.progress = 0,
    this.data,
    this.error,
  });

  UploadState copyWith({
    bool? isLoading,
    double? progress,
    String? data,
    String? error,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
