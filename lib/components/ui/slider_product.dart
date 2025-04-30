import 'package:carousel_slider/carousel_slider.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/preview_image.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderProductCustom extends StatefulWidget {
  const SliderProductCustom({super.key, required this.imagesUrl});
  final List<String> imagesUrl;

  @override
  State<SliderProductCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<SliderProductCustom> {
  int activeIndex = 0;
  bool isHover = false;

  final CarouselSliderController _controller = CarouselSliderController();

  void scrollAutomatically(ScrollController scrollController, int index) {
    if (scrollController.hasClients) {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double valueOffset = Responsive.isMobile(context) ? 60 : 120;

      if (currentScroll % 1 == 0) {
        if (activeIndex == 0) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (activeIndex == widget.imagesUrl.length - 1) {
          scrollController.animateTo(
            maxScroll,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (currentScroll < maxScroll - 10) {
          scrollController.animateTo(
            scrollController.offset + valueOffset,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = List.generate(
      widget.imagesUrl.length,
      (index) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              widget.imagesUrl[index],
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    double isWrap = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment:
          isWrap < 1200 ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isDesktop(context)
                  ? 600
                  : // Laptop
                  Responsive.isTablet(context)
                      ? 700
                      : // iPad
                      double.infinity, // Mobile
            ),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: items.length,
                  itemBuilder: (context, index, realIndex) => MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHover = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHover = false;
                      });
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: isHover && activeIndex == index ? 0.99 : 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: !Responsive.isMobile(context)
                              ? BorderRadius.circular(10)
                              : null,
                          image: DecorationImage(
                            image: AssetImage(
                              widget.imagesUrl[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  options: CarouselOptions(
                    height: !Responsive.isMobile(context) ? 500.0 : 300.0,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    aspectRatio: 1 / 1,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                  ),
                ),
                (!Responsive.isMobile(context))
                    ? Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedSmoothIndicator(
                            activeIndex: activeIndex,
                            count: items.length,
                            effect: SwapEffect(
                              dotColor: Colors.white,
                              activeDotColor: AppColors.primary,
                              dotHeight: 10,
                              dotWidth: 10,
                            ),
                            onDotClicked: (index) => {
                              _controller.animateToPage(index),
                            },
                          ),
                        ),
                      )
                    : Positioned(
                        bottom: 20,
                        right: 20,
                        left: 20,
                        child: PreviewImage(
                          scrollAutomatically: scrollAutomatically,
                          direction: Axis.horizontal,
                          imagesUrl: widget.imagesUrl,
                          activeIndex: activeIndex,
                          onTap: (index) {
                            activeIndex = index;
                            _controller.animateToPage(index);
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
        if (!Responsive.isMobile(context))
          PreviewImage(
            scrollAutomatically: scrollAutomatically,
            direction: Axis.vertical,
            imagesUrl: widget.imagesUrl,
            activeIndex: activeIndex,
            onTap: (index) {
              _controller.animateToPage(index);
            },
          ),
      ],
    );
  }
}
