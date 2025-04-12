import 'dart:ui';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatefulWidget {
  PreviewImage({
    super.key,
    this.direction = Axis.horizontal,
    required this.imagesUrl,
    required this.activeIndex,
    required this.onTap,
    required this.scrollAutomatically,
  });

  final List<String> imagesUrl;
  final int activeIndex;
  final Function onTap;
  final Axis direction;
  final Function(ScrollController, int) scrollAutomatically;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  int? indexHover;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PreviewImage oldWidget) {
    if (oldWidget.activeIndex != widget.activeIndex) {
      widget.scrollAutomatically(_scrollController, widget.activeIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.direction == Axis.horizontal ? 80 : double.infinity,
      width: widget.direction == Axis.horizontal ? double.infinity : 120,
      padding: Responsive.isMobile(context)
          ? EdgeInsets.symmetric(
              horizontal: widget.imagesUrl.length >= 4
                  ? 50
                  : MediaQuery.of(context).size.width /
                          widget.imagesUrl.length -
                      60,
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(10) : null,
            decoration: BoxDecoration(
              color: Responsive.isMobile(context)
                  ? Colors.white.withAlpha(50)
                  : Colors.white.withAlpha(0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: widget.direction,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => MouseRegion(
                        onHover: (_) {
                          setState(() {
                            indexHover = index;
                          });
                        },
                        child: GestureDetector(
                          onTap: () => {
                            widget.onTap(index),
                            widget.scrollAutomatically(
                                _scrollController, widget.activeIndex),
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width:
                                  widget.direction == Axis.horizontal ? 60 : 70,
                              height: widget.direction == Axis.horizontal
                                  ? 40
                                  : 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: widget.activeIndex == index ? 2 : 0,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(widget.imagesUrl[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                        height: 10,
                      ),
                  itemCount: widget.imagesUrl.length),
            ),
          ),
        ),
      ),
    );
  }
}
