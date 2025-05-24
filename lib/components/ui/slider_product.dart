import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/preview_image.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderProductCustom extends StatefulWidget {
  const SliderProductCustom(
      {super.key, required this.imagesUrl, this.isLoading = false});
  final List<String> imagesUrl;
  final bool isLoading;

  @override
  State<SliderProductCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<SliderProductCustom> {
  late int activeIndex;

  bool isHover = false;

  final CarouselSliderController _controller = CarouselSliderController();
  @override
  void initState() {
    super.initState();
    activeIndex = widget.imagesUrl.isNotEmpty ? 0 : -1;
  }

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
      (index) => SizedBox(
        child: CachedNetworkImage(
          imageUrl: widget.imagesUrl[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 350, // hoặc chiều cao bạn muốn
          placeholder: (context, url) => const SkeletonImage(
            imageHeight: 160,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/image_default_error.png',
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
                widget.isLoading == false
                    ? CarouselSlider.builder(
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
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: (widget.imagesUrl[index]),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SkeletonImage(
                                    imageHeight: !Responsive.isMobile(context)
                                        ? 500.0
                                        : 300.0, // hoặc chiều cao bạn muốn
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/image_default_error.png',
                                    fit: BoxFit.cover,
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                )),
                          ),
                        ),
                        options: CarouselOptions(
                          height: !Responsive.isMobile(context) ? 500.0 : 300.0,
                          enlargeCenterPage: false,
                          autoPlay: false,
                          aspectRatio: 1 / 1,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      )
                    : SkeletonImage(
                        imageHeight: !Responsive.isMobile(context) ? 450 : 300,
                        imageWidth: double.infinity,
                      ),
                (!Responsive.isMobile(context))
                    ? Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: activeIndex >= 0 && widget.imagesUrl.isNotEmpty
                              ? AnimatedSmoothIndicator(
                                  activeIndex: activeIndex,
                                  count: items.length,
                                  effect: SwapEffect(
                                    dotColor: Colors.black12,
                                    activeDotColor: AppColors.primary,
                                    dotHeight: 10,
                                    dotWidth: 10,
                                  ),
                                  onDotClicked: (index) => {
                                    _controller.animateToPage(index),
                                  },
                                )
                              : const SizedBox(
                                  height: 10,
                                  width: 100,
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
                          isLoading: widget.isLoading,
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
          SizedBox(
            child: PreviewImage(
              scrollAutomatically: scrollAutomatically,
              direction: Axis.vertical,
              imagesUrl: widget.imagesUrl,
              activeIndex: activeIndex,
              onTap: (index) {
                _controller.animateToPage(index);
              },
            ),
          ),
      ],
    );
  }
}
