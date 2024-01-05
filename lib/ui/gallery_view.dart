import 'package:fancy_gallery/ui/app_constants.dart';
import 'package:fancy_gallery/ui/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GalleryView extends HookWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagingController =
        useState(PagingController<int, String>(firstPageKey: 1)).value;
    useEffect(() {
      pagingController.appendPage(
        List.generate(20, (e) => AppConstants.imageUrl(e)),
        20,
      );
      pagingController.addPageRequestListener(
        (page) async {
          final key =
              pagingController.nextPageKey ?? pagingController.firstPageKey;
          await Future.delayed(const Duration(milliseconds: 200));

          pagingController.appendPage(
            List.generate(20, (e) => AppConstants.imageUrl(key + e)),
            key + 20,
          );
        },
      );

      return () {
        pagingController.removePageRequestListener((_) {});
        pagingController.dispose();
      };
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: PagedGridView<int, String>(
        pagingController: pagingController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 182 * 1.3,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
        ),
        builderDelegate: PagedChildBuilderDelegate(
          newPageProgressIndicatorBuilder: (_) =>
              const CircularProgressIndicator.adaptive(),
          itemBuilder: (context, _, index) {
            final item = (pagingController.itemList ?? [])[index];
            return AppNetworkImage(
              url: item,
              size: const Size.square(200),
              borderRadius: 8,
            ).animate(
              effects: [
                const FadeEffect(),
              ],
            );
          },
        ),
      ),
    );
  }
}
/*
final _transformationController = TransformationController();
TapDownDetails _doubleTapDetails;

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onDoubleTapDown: (d) => _doubleTapDetails = d,
    onDoubleTap: _handleDoubleTap,
    child: Center(
      child: InteractiveViewer(
        transformationController: _transformationController,
        /* ... */
      ),
    ),
  );
}

void _handleDoubleTap() {
  if (_transformationController.value != Matrix4.identity()) {
    _transformationController.value = Matrix4.identity();
  } else {
    final position = _doubleTapDetails.localPosition;
    // For a 3x zoom
    _transformationController.value = Matrix4.identity()
      ..translate(-position.dx * 2, -position.dy * 2)
      ..scale(3.0);
    // Fox a 2x zoom
    // ..translate(-position.dx, -position.dy)
    // ..scale(2.0);
  }
}*/