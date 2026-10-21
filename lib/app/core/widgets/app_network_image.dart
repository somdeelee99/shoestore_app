import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../services/asset_service.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 12,
    this.background = AppColors.surfaceAlt,
  });

  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final url = AssetService.url(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? _placeholder()
          : CachedNetworkImage(
              imageUrl: url,
              width: width,
              height: height,
              fit: fit,
              placeholder: (_, __) => _shimmer(),
              errorWidget: (_, __, ___) => _placeholder(),
            ),
    );
  }

  Widget _shimmer() => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(width: width, height: height, color: background),
      );

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: background,
        child: const Icon(Icons.image_outlined, color: AppColors.textHint),
      );
}
