import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.onRetry,
    required this.errorMessage,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontStyle: .italic,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: .all(.circular(4)),
                side: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
            onPressed: onRetry,
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
