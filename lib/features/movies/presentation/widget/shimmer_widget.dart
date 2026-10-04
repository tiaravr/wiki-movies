import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.shape,
  });

  final double height;
  final double width;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFFE5E7EB),
      highlightColor: Color(0xFFF1F1F5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.white, shape: shape),
      ),
    );
  }
}
