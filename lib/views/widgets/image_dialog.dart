import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'app_network_image.dart';

class ImageDialog extends StatelessWidget {
  final String image;
  const ImageDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(tag: image, child: ImageSection(image: image)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Generated Image ${image.split('/')[4]}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Author: Mr(s) person ${image.split('/')[4]}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is an image of "Generated Image ${image.split('/')[4]}". It is gotten from Lorem Picsum and used for Canverro Mobile App Developer Test.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatefulWidget {
  final String image;
  const ImageSection({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  TapDownDetails? _tapDetails;
  AnimationController? _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FlipEffect()],
      child: GestureDetector(
        onTapDown: (d) => _tapDetails = d,
        onTap: _handleTap,
        child: Center(
          child: InteractiveViewer(
            transformationController: _transformationController,
            child: AppNetworkImage(
              url: widget.image,
              size: const Size.square(400),
              fit: BoxFit.cover,
              borderRadius: 8,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    Matrix4 endMatrix;
    Offset position = _tapDetails!.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController!),
    );
    _animationController?.forward(from: 0);
  }
}
