import 'package:flutter/cupertino.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
 required this.image
  });
 final String image ;

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration:const BoxDecoration(
      borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(50),bottomStart: Radius.circular(50)),),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(image),
    );
  }
}
