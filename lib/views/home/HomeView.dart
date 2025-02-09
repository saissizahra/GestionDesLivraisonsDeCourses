import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';
import 'package:mkadia/models/category.dart';
import 'package:mkadia/models/product.dart';
import 'package:mkadia/views/home/widget/AllProductsPage.dart';
import 'package:mkadia/views/home/widget/SearchLoc.dart';
import 'package:mkadia/views/home/widget/productCard.dart';
import 'package:mkadia/views/home/widget/promo.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView>createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  int currentSlider = 0;
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    List<List<Product>> selectedCategories = [
      all,
      fruits,
      vegetables,
      milkAndEggs,
      meat,
    ];
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: TColor.primaryText,
                  elevation: 0,
                  toolbarHeight: 160,
                  title: const SearchLoc(),
                ),
              ),
              
              //todo: category

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110, 
                      child: Center( 
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedIndex = index;
                                });
                              },

                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  //mnin kan cliqiw 3la chi catg lcolor mazwinch hh a revenir 
                                  color: selectedIndex == index 
                                  ?Colors.amber
                                  :Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 68, 
                                      width: 68,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade300, width: 2), 
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(2, 2), 
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8), 
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8), 
                                        child: Image.asset(
                                          categories[index].image,
                                          fit: BoxFit.contain, 
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      categories[index].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // todo: promo

                    promo(
                      currentSlide: currentSlider,
                      onChange: (value) {
                        setState(() {
                          currentSlider = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // todo: barre de popular products

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Popular products",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        
                        //todo: barre de see all 

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProductsPage(
                                  products: selectedCategories[selectedIndex], 
                                  categoryName: categories[selectedIndex].name,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "see all",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),


                      ],
                    ),

                    // todo: grid de popular products 

                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: selectedCategories[selectedIndex].take(8).length, 
                      itemBuilder: (context, index) {
                        return ProductCard(product: selectedCategories[selectedIndex][index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
