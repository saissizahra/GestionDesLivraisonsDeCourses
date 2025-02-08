import 'package:flutter/material.dart';
import 'package:flutter_application_catmkadia/common/color_extension.dart';
import 'package:flutter_application_catmkadia/models/product.dart';
import 'package:flutter_application_catmkadia/views/cart/cart.dart';
import 'package:flutter_application_catmkadia/views/detail/widget/addToCart.dart';
import 'package:flutter_application_catmkadia/views/detail/widget/description.dart';
import 'package:flutter_application_catmkadia/views/detail/widget/detailItems.dart';
import 'package:flutter_application_catmkadia/views/detail/widget/DetailImages.dart';

class Detail extends StatefulWidget {
  final Product product;
  const Detail({super.key, required this.product});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int currentImage = 0;
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), 
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            toolbarHeight: 80,
            backgroundColor: TColor.primaryText,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios, 
                color: Colors.white, 
                size: 28
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Product Details",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cart()),
                  );
                },
              ),
            ],

          ),
        ),
      ),
      floatingActionButton: AddToCart(product: widget.product), // Le bouton flottant ici
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            DetailImages(
              image: widget.product.image,
              onChange: (index) {
                setState(() {
                  currentImage = index;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentImage == index ? 15 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentImage == index ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailItems(product: widget.product),
                  const SizedBox(height: 20),
                  Description(description: widget.product.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
