import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/models/products_model.dart';
import '../consts/global_colors.dart';
import '../pages/product_detail.dart';

class FeedsWidget extends StatelessWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsModelProvider = Provider.of<ProductsModel>(context);

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ProductDetails(id: productsModelProvider.id.toString(),),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            text: '\$',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(236, 216, 0, 1.0)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${productsModelProvider.price}",
                                  style: TextStyle(
                                      color: lightTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                    ),
                    const Icon(IconlyBold.category),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  height: size.height * 0.2,
                  width: double.infinity,
                  errorWidget: const Icon(
                    IconlyBold.danger,
                    color: Colors.red,
                    size: 28,
                  ),
                  imageUrl: productsModelProvider.images!,
                  boxFit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productsModelProvider.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize:20,
                    fontStyle: FontStyle.italic,
                    //  fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
