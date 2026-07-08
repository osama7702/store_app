import 'package:flutter/material.dart';

import '../../../../core/widgets/app_network_image.dart';

/// Full-screen, zoomable preview of a product image.
class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AppNetworkImage(url: imageUrl),
          ),
        ),
      ),
    );
  }
}
