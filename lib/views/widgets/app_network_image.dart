import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final bool isCircular;
  final bool cacheImage;
  final Size? size;
  final double borderRadius;
  final Widget? errorWidget;
  final String? errorAssetImage;

  const AppNetworkImage({
    Key? key,
    String? url,
    this.fit,
    this.isCircular = false,
    this.cacheImage = true,
    this.size = const Size.square(40),
    this.borderRadius = 0,
    this.errorWidget,
    this.errorAssetImage,
  })  : imageUrl = url ?? "",
        assert(errorWidget == null || errorAssetImage == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      cache: cacheImage,
      height: size?.height,
      width: size?.width,
      clipBehavior: Clip.hardEdge,
      fit: BoxFit.fill,
      retries: 3,
      shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Theme.of(context).colorScheme.primary,
              child: Container(
                height: size?.height,
                width: size?.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius:
                      isCircular ? null : BorderRadius.circular(borderRadius),
                ),
              ),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              height: size?.height,
              width: size?.width,
              fit: fit,
            );
          case LoadState.failed:
            if (errorWidget != null) {
              return errorWidget!;
            }
            final errorImage = errorAssetImage ?? '';
            if (errorImage.isNotEmpty) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius:
                      isCircular ? null : BorderRadius.circular(borderRadius),
                  shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                ),
                child: const Icon(Icons.error),
              );
            }
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius:
                    isCircular ? null : BorderRadius.circular(borderRadius),
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: const Icon(
                Icons.warning,
                color: Colors.white,
                size: 40,
              ),
            );
        }
      },
    );
  }
}
