import 'package:fancy_gallery/shared/app_constants.dart';
import 'package:fancy_gallery/views/widgets/app_network_image.dart';
import 'package:fancy_gallery/views/widgets/image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GalleryView extends HookWidget {
  const GalleryView({super.key});

  /// Hook that manages a [PagingController] for paginated data loading.
  ///
  /// This hook initializes and manages a [PagingController] for handling
  /// paginated data loading in the application. It generates and appends pages
  /// of data to the controller, triggering loading and appending of subsequent
  /// pages when needed. The hook sets up a listener for page requests and
  /// asynchronously loads and appends the next set of data.
  ///
  /// The hook generates a specified length of data per loading cycle and
  /// asynchronously simulates loading for the next set of data after a delay
  /// of 200 milliseconds. The [PagingController] is disposed of when the hook
  /// is unmounted, ensuring proper resource cleanup.
  PagingController<int, String> _usePagingController() {
    final cont = useState(PagingController<int, String>(firstPageKey: 1)).value;

    useEffect(() {
      const lpload = 16; // Length per loading
      cont.appendPage(
        List.generate(lpload, (e) => AppConstants.imageUrl(e)),
        lpload,
      );
      cont.addPageRequestListener(
        (page) async {
          final key = cont.nextPageKey ?? cont.firstPageKey;
          await Future.delayed(const Duration(milliseconds: 200));
          cont.appendPage(
            List.generate(lpload, (e) => AppConstants.imageUrl(key + e)),
            key + lpload,
          );
        },
      );

      return () {
        cont.removePageRequestListener((_) {});
        cont.dispose();
      };
    }, []);
    return cont;
  }

  @override
  Widget build(BuildContext context) {
    final pagingController = _usePagingController();
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
            return Animate(
              effects: const [
                FadeEffect(),
                ShakeEffect(),
              ],
              child: Hero(
                tag: item,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => ImageDialog(image: item),
                  ),
                  child: AppNetworkImage(
                    url: item,
                    size: const Size.square(200),
                    borderRadius: 8,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
