import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageShimmerWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxShape shape;
  final BoxFit fit;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CustomImageShimmerWidget({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _buildErrorWidget();
    }

    if (url.startsWith('http') || url.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        color: color,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
            ),
          ),
        ),
        placeholder: (context, url) => _buildShimmer(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    }

    if (url.endsWith('.svg')) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        ),
        child: SvgPicture.asset(
          url,
          height: height,
          width: width,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        ),
      );
    }

    // Check if it is a local file (starts with / or file://)
    if (url.startsWith('/') || url.startsWith('file://')) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          image: DecorationImage(
            image: FileImage(File(url.replaceFirst('file://', ''))),
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          ),
        ),
      );
    }

    // Default to asset image
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        image: DecorationImage(
          image: AssetImage(url),
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.white54,
        ),
      ),
    );
  }
}
