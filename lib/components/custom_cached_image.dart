import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final BoxShape shape;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: shape == BoxShape.circle
          ? BorderRadius.zero
          : BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.grey.shade200, shape: shape),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xffD7A753),
                ), // Gold theme match
              ),
            ),
          ),
        ),
        // Error widget shown if the image fails to load
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: shape),
          child: Icon(
            Icons.broken_image_rounded,
            color: Colors.grey.shade400,
            size: width != null ? width! * 0.4 : 30,
          ),
        ),
      ),
    );
  }
}
