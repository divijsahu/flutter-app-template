import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'my_images.dart';

/// Different loading styles for the image placeholder
enum LoadingStyle {
  shimmer, // Animated shimmer effect
  skeleton, // Simple skeleton placeholder
  fadeIn, // Subtle background only
  storeIcon, // Generic store icon
}

/// A smart image widget that automatically handles both regular images and SVG files
/// with caching, loading states, and error handling.
class SmartImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final LoadingStyle loadingStyle;

  const SmartImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.padding,
    this.loadingStyle = LoadingStyle.shimmer,
  });

  /// Helper method to check if the image URL is an SVG
  bool _isSvgImage(String imageUrl) {
    return imageUrl.toLowerCase().endsWith('.svg') ||
        imageUrl.toLowerCase().contains('.svg?') ||
        imageUrl.toLowerCase().contains('format=svg') ||
        imageUrl.toLowerCase().contains('image/svg');
  }

  /// Default loading placeholder
  Widget get _defaultPlaceholder {
    switch (loadingStyle) {
      case LoadingStyle.shimmer:
        return _buildShimmerPlaceholder();
      case LoadingStyle.skeleton:
        return _buildSkeletonPlaceholder();
      case LoadingStyle.fadeIn:
        return _buildFadeInPlaceholder();
      case LoadingStyle.storeIcon:
        return _buildStoreIconPlaceholder();
    }
  }

  /// Shimmer loading effect
  Widget _buildShimmerPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade100,
            Colors.grey.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: _ShimmerEffect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// Simple skeleton placeholder
  Widget _buildSkeletonPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: (width ?? 80) * 0.6,
          height: (height ?? 80) * 0.6,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// Subtle fade-in placeholder
  Widget _buildFadeInPlaceholder() {
    return Container(width: width, height: height, color: Colors.grey.shade100);
  }

  /// Store icon placeholder
  Widget _buildStoreIconPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.storefront_outlined,
          size: 24,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  /// Default error widget
  Widget get _defaultErrorWidget => Container(
        width: width,
        height: height,
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isSvgImage(imageUrl)) {
      // Handle SVG images
      imageWidget = SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (context) => placeholder ?? _defaultPlaceholder,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _defaultErrorWidget,
      );
    } else {
      // Handle regular images with caching
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _defaultPlaceholder,
        errorWidget: (context, url, error) =>
            errorWidget ?? _defaultErrorWidget,
      );
    }

    // Apply padding if specified
    if (padding != null) {
      return Padding(padding: padding!, child: imageWidget);
    }

    return imageWidget;
  }
}

/// Simple shimmer effect widget for loading animation
class _ShimmerEffect extends StatefulWidget {
  final Widget child;

  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                Colors.grey.shade300,
                Colors.white.withOpacity(0.8),
                Colors.grey.shade300,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// ===== SMARTIMAGEWIDGET HELPER METHODS =====
// These methods use MyImages paths to create SmartImageWidget instances

/// Helper class for creating SmartImageWidget instances with predefined settings
class SmartImageHelpers {
  SmartImageHelpers._();

  /// Create a SmartImageWidget for network images with common settings
  static SmartImageWidget networkImage(
    String imageName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    LoadingStyle loadingStyle = LoadingStyle.shimmer,
  }) {
    return SmartImageWidget(
      imageUrl: MyImages.networkImage(imageName),
      width: width,
      height: height,
      fit: fit,
      loadingStyle: loadingStyle,
    );
  }

  /// Create a SmartImageWidget for user avatars with default settings
  static SmartImageWidget userAvatar(
    String userId, {
    double size = 50.0,
    LoadingStyle loadingStyle = LoadingStyle.storeIcon,
  }) {
    return SmartImageWidget(
      imageUrl: MyImages.userAvatar(userId),
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingStyle: loadingStyle,
    );
  }

  /// Create a SmartImageWidget for product images with default settings
  static SmartImageWidget productImage(
    String productId, {
    double? width,
    double? height,
    int variant = 1,
    BoxFit fit = BoxFit.cover,
    LoadingStyle loadingStyle = LoadingStyle.shimmer,
  }) {
    return SmartImageWidget(
      imageUrl: MyImages.productImage(productId, variant: variant),
      width: width,
      height: height,
      fit: fit,
      loadingStyle: loadingStyle,
    );
  }

  /// Create a SmartImageWidget for category images
  static SmartImageWidget categoryImage(
    String categoryId, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    LoadingStyle loadingStyle = LoadingStyle.fadeIn,
  }) {
    return SmartImageWidget(
      imageUrl: MyImages.networkImage('categories/category_$categoryId.jpg'),
      width: width,
      height: height,
      fit: fit,
      loadingStyle: loadingStyle,
    );
  }
}
