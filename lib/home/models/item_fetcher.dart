import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FetchingStatus {
  initial,
  loading,
  success,
  failure,
}

class ItemFetcher<T> extends Equatable {
  const ItemFetcher({
    required this.connectionState,
    required this.error,
    required this.item,
  });
  const ItemFetcher.initial({
    this.item,
    this.connectionState = FetchingStatus.initial,
    this.error = '',
  });

  const ItemFetcher.loading()
    : connectionState = FetchingStatus.loading,
      error = '',
      item = null;

  const ItemFetcher.refresh(this.item)
    : connectionState = FetchingStatus.loading,
      error = '';

  const ItemFetcher.failed(this.error)
    : item = null,
      connectionState = FetchingStatus.failure;

  const ItemFetcher.success(T this.item)
    : connectionState = FetchingStatus.success,
      error = '';
  final FetchingStatus connectionState;
  final String error;
  final T? item;

  ItemFetcher<T> copyWith({
    T? item,
    FetchingStatus? connectionState,
    String? error,
  }) {
    return ItemFetcher<T>(
      item: item ?? this.item,
      connectionState: connectionState ?? this.connectionState,
      error: error ?? this.error,
    );
  }

  bool get hasError =>
      error.trim().isNotEmpty && (connectionState == FetchingStatus.failure);
  bool get isLoading => connectionState == FetchingStatus.loading;
  bool get hasData =>
      connectionState == FetchingStatus.success &&
      error.trim().isEmpty &&
      item != null;

  Widget when({
    required Widget Function(T item) success,
    required Widget Function(String error) failure,
    required Widget Function() loading,
    Widget Function()? initial,
  }) {
    if (hasData) {
      return success(item as T);
    }
    if (hasError) {
      return failure(error);
    }
    if (isLoading) {
      return loading();
    }
    return initial?.call() ?? const SizedBox.shrink();
  }

  @override
  List<Object?> get props => [item, connectionState, error];

  @override
  String toString() {
    return 'ItemFetcher(item: $item, connectionState: $connectionState,'
        ' error: $error,)';
  }
}
