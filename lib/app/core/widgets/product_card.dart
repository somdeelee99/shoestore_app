import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/product_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../utils/formatters.dart';
import 'app_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.width,
    this.showRating = true,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final double? width;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: AppSizes.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.08,
                  child: AppNetworkImage(
                    product.thumbnail,
                    radius: AppSizes.radiusLg,
                    width: double.infinity,
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    left: 8.w,
                    top: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                if (onFavorite != null)
                  Positioned(
                    right: 6.w,
                    top: 6.h,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16.r,
                          color: isFavorite ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.brand != null)
                    Text(
                      product.brand!.toUpperCase(),
                      style: TextStyle(fontSize: 9.sp, color: AppColors.textHint, letterSpacing: .6),
                    ),
                  SizedBox(height: 2.h),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Formatters.money(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ),
                      if (showRating)
                        Row(
                          children: [
                            Icon(Icons.star_rounded, size: 12.r, color: AppColors.accent),
                            SizedBox(width: 2.w),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal, compact product row used on cart/checkout summaries.
class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    this.price,
    this.trailing,
    this.onTap,
    this.size = 64,
  });

  final String? image;
  final String title;
  final String? subtitle;
  final String? price;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppNetworkImage(image, width: size.w, height: size.w, radius: AppSizes.radius),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(subtitle!, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                ],
                if (price != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    price!,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
