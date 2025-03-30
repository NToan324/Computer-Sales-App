import 'package:carousel_slider/carousel_slider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/product_details/widgets/preview_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderProductCustom extends StatefulWidget {
  const SliderProductCustom({super.key, required this.imagesUrl});

  final List<String> imagesUrl;

  @override
  State<SliderProductCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<SliderProductCustom> {
  int activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

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

    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: items.length,
          itemBuilder: (context, index, realIndex) => items[index],
          //Slider Container properties
          options: CarouselOptions(
              height: Responsive.isDesktop(context) ? 550.0 : 400.0,
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
              }),
        ),
        // Positioned.fill(
        //   bottom: 40,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: AnimatedSmoothIndicator(
        //       activeIndex: activeIndex,
        //       count: items.length,
        //       effect: SwapEffect(
        //         dotColor: Colors.white,
        //         activeDotColor: AppColors.primary,
        //         dotHeight: 10,
        //         dotWidth: 10,
        //       ),
        //       onDotClicked: (index) => {
        //         _controller.animateToPage(index),
        //       },
        //     ),
        //   ),
        // )
        Positioned(
          bottom: 40,
          right: 20,
          left: 20,
          child: PreviewImage(
            imagesUrl: widget.imagesUrl,
            activeIndex: activeIndex,
            onTap: (index) {
              _controller.animateToPage(index);
            },
          ),
        )
      ],
    );
  }
}
