import 'package:flutter/material.dart';
import 'package:wiki_movies/features/movies/presentation/widget/shimmer_widget.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({super.key, this.itemCount = 10});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemBuilder: (_, _) {
        return ListTile(
          title: ShimmerWidget(
            height: 16,
            width: 100,
            shape: BoxShape.rectangle,
          ),
          subtitle: ShimmerWidget(
            height: 12,
            width: 80,
            shape: BoxShape.rectangle,
          ),
          leading: ShimmerWidget(
            height: 75,
            width: 50,
            shape: BoxShape.rectangle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: itemCount,
    );
  }
}
