import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class MovieCategory extends Equatable {
  const MovieCategory._({
    required this.id,
    required this.label,
    required this.minRate,
    this.maxRate,
  });

  final String id;
  final String label;
  final num minRate;
  final num? maxRate;

  static const MovieCategory all = MovieCategory._(
    id: 'all',
    label: 'All',
    minRate: 0,
  );

  static const MovieCategory bad = MovieCategory._(
    id: 'bad',
    label: 'Bad',
    minRate: 4,
    maxRate: 6,
  );

  static const MovieCategory good = MovieCategory._(
    id: 'good',
    label: 'Good',
    minRate: 6,
    maxRate: 8,
  );

  static const MovieCategory great = MovieCategory._(
    id: 'great',
    label: 'Great',
    minRate: 8,
    maxRate: 9,
  );

  static const MovieCategory recommend = MovieCategory._(
    id: 'recommend',
    label: 'Recommend',
    minRate: 9,
  );

  static const List<MovieCategory> values = [all, bad, good, great, recommend];

  bool matches(num? voteAverage) {
    final rate = voteAverage ?? 0;
    final upperBound = maxRate;

    return rate >= minRate && (upperBound == null || rate < upperBound);
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
