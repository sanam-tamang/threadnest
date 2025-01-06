// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.prefix,
    this.borderRadius,
    this.fit,
    this.isCircular = false,
    this.radius,
    this.backgroundColor,
  });

  final String? imageUrl;
  final String? prefix;
  final double? borderRadius;
  final BoxFit? fit;
  final bool isCircular;
  final double? radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = (prefix ??
            "https://zzpafhzqyklbkmcogjvs.supabase.co/storage/v1/object/public/") +
        (imageUrl ?? '');

    return imageUrl != null
        ? isCircular
            ? CircleAvatar(
                radius: radius,
                backgroundImage: ExtendedNetworkImageProvider(
                  fullImageUrl,
                  cache: true,
                ),
                backgroundColor: Colors.transparent,
                onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.error),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                child: ExtendedImage.network(
                  cacheRawData: true,
                  clearMemoryCacheIfFailed: true,
                  fullImageUrl,
                  fit: fit ?? BoxFit.cover,
                  cache: true,
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Center(
                          child: CircularProgressIndicator(
                            value: state.loadingProgress?.expectedTotalBytes !=
                                        null &&
                                    state.loadingProgress
                                            ?.cumulativeBytesLoaded !=
                                        null
                                ? state.loadingProgress!.cumulativeBytesLoaded /
                                    state.loadingProgress!.expectedTotalBytes!
                                : null,
                          ),
                        );
                      case LoadState.failed:
                        return const Center(child: Icon(Icons.error));
                      case LoadState.completed:
                        return null; // Default rendering
                    }
                  },
                ),
              )
        : isCircular
            ? CircleAvatar(
                radius: radius,
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: backgroundColor ??
                        Theme.of(context).colorScheme.surfaceDim),
              );
  }
}
