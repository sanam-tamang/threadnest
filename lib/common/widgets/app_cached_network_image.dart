import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatefulWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.prefix,
    this.borderRadius,
    this.fit,
    this.isCircular = false,
  });

  final String? imageUrl;
  final String? prefix;
  final double? borderRadius;
  final BoxFit? fit;
  final bool isCircular;

  @override
  State<AppCachedNetworkImage> createState() => _AppCachedNetworkImageState();
}

class _AppCachedNetworkImageState extends State<AppCachedNetworkImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fullImageUrl = (widget.prefix ??
            "https://zzpafhzqyklbkmcogjvs.supabase.co/storage/v1/object/public/") +
        (widget.imageUrl ?? '');

    return widget.imageUrl != null
        ? widget.isCircular
            ? CircleAvatar(
                backgroundImage: ExtendedNetworkImageProvider(
                  fullImageUrl,
                  cache: true,
                ),
                backgroundColor: Colors.transparent,
                onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.error),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                child: ExtendedImage.network(
                  cacheRawData: true,
                  clearMemoryCacheIfFailed: true,
                  fullImageUrl,
                  fit: widget.fit ?? BoxFit.cover,
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
        : const CircleAvatar();
  }

  @override
  bool get wantKeepAlive => true;
}
