import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class ImageDialogWidget extends StatefulWidget {
  final String imageUrl;
  final List<String>? imageUrls;
  const ImageDialogWidget({super.key, required this.imageUrl, this.imageUrls});

  @override
  State<ImageDialogWidget> createState() => _ImageDialogWidgetState();
}

class _ImageDialogWidgetState extends State<ImageDialogWidget> {
  late final List<String> _images;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _images = (widget.imageUrls?.isNotEmpty ?? false) ? widget.imageUrls! : [widget.imageUrl];
    _currentIndex = _images.contains(widget.imageUrl) ? _images.indexOf(widget.imageUrl) : 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    bool hasMultipleImages = _images.length > 1;

    return Dialog(
      backgroundColor: Colors.transparent,surfaceTintColor: Colors.transparent,
      child: Stack(clipBehavior: Clip.none, children: [
          SizedBox(
            width: double.infinity,
            height: hasMultipleImages ? MediaQuery.of(context).size.height * 0.5 : null,
            child: hasMultipleImages ? PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) => _imageWithClose(context, _images[index]),
            ) : _imageWithClose(context, _images.first),
          ),

          if(hasMultipleImages && _currentIndex > 0)
            PositionedDirectional(start: 0, top: 0, bottom: 0,
              child: Center(child: _ArrowButton(icon: Icons.arrow_back_ios_new, onTap: () => _goToPage(_currentIndex - 1))),
            ),

          if(hasMultipleImages && _currentIndex < _images.length - 1)
            PositionedDirectional(end: 0, top: 0, bottom: 0,
              child: Center(child: _ArrowButton(icon: Icons.arrow_forward_ios, onTap: () => _goToPage(_currentIndex + 1))),
            ),
        ]),
    );
  }

  // Center loosens the constraints so the Stack wraps the rendered image and the close button hugs its top-right corner
  Widget _imageWithClose(BuildContext context, String url) {
    return Center(
      child: Stack(clipBehavior: Clip.none, children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: CustomImageWidget(image: url, fit: BoxFit.contain),
        ),
        PositionedDirectional(top: 0, end: 0,
          child: InkWell(onTap: ()=> Navigator.of(context).pop(), splashColor: Colors.transparent, highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(decoration: BoxDecoration(color: Theme.of(context).hintColor, borderRadius: BorderRadius.circular(100)),
                  child: Icon(Icons.clear, color: Theme.of(context).cardColor, size: 25)),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, splashColor: Colors.transparent, highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(color: Theme.of(context).hintColor, shape: BoxShape.circle),
        child: Icon(icon, color: Theme.of(context).cardColor, size: Dimensions.iconSizeDefault),
      ),
    );
  }
}
