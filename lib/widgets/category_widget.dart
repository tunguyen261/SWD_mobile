import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/consts/global_colors.dart';
import 'package:garden_app/models/categories_model.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);
  static const img =
      "https://www.google.com.vn/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Fvector-art%2F7396756-balcony-garden-flat-with-air-conditioner-on-white-background&psig=AOvVaw0QIJ4xcq98P5TSoSNWSYQR&ust=1679120379867000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjcuf-o4v0CFQAAAAAdAAAAABAE";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final categoriesModelProvider = Provider.of<CategoriesModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.45,
              width: size.width * 0.45,
              errorWidget: const Icon(
                IconlyBold.danger,
                color: Colors.red,
                size: 28,
              ),
              imageUrl:
                  "https://static.vecteezy.com/system/resources/previews/007/396/756/original/balcony-garden-flat-with-air-conditioner-on-white-background-free-vector.jpg",
              boxFit: BoxFit.fill,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: ShaderMask(
                blendMode: BlendMode.multiply,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.green,
                    Colors.yellow,
                    Colors.white
                  ],
                ).createShader(bounds),
                child: Text(
                  categoriesModelProvider.namePackageType.toString(),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
              // Text(
              //   categoriesModelProvider.namePackageType.toString(),
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //     backgroundColor: lightCardColor.withOpacity(1),
              //   ),
              // ),
              ),
        ],
      ),
    );
  }
}
