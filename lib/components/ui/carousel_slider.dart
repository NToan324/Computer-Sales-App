import 'package:carousel_slider/carousel_slider.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSliderCustom extends StatefulWidget {
  const CarouselSliderCustom({super.key, required this.imagesUrl});

  final List<String> imagesUrl;

  @override
  State<CarouselSliderCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<CarouselSliderCustom> {
  int activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    var items = List.generate(
      widget.imagesUrl.length,
      (index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(widget.imagesUrl[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    return Column(
      spacing: 10,
      children: [
        if (Responsive.isMobile(context))
          SizedBox(
            height: 10,
          ),
        SizedBox(
          child: CarouselSlider.builder(
            carouselController: _controller,
            itemCount: items.length,
            itemBuilder: (context, index, realIndex) => items[index],
            //Slider Container properties
            options: CarouselOptions(
                height: Responsive.isDesktop(context) ? 550.0 : 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                }),
          ),
        ),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: items.length,
          effect: SwapEffect(
            activeDotColor: AppColors.primary,
            dotHeight: 7,
            dotWidth: 7,
          ),
          onDotClicked: (index) => {
            _controller.animateToPage(index),
          },
        )
      ],
    );
  }
}
