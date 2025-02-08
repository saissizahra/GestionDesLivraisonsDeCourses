class Product {
  final String name;
  final String description;
  final String image;
  final double price;
  final String weight;
  final double rate;
  final String category;
  int quantity;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.weight,
    required this.rate,
    required this.category,
    this.quantity=1
  });
}
final List<Product> all = [
  ...fruits,
  ...vegetables,
  ...meat,
  ...milkAndEggs,
];

final List<Product> fruits = [
  Product(
    name:"Orange",
    description: "The orange is a juicy, sweet, and tangy fruit from the citrus family.",
    image:"assets/img/fruits.png",
    price:1.2,
    category:"Fruits",
    weight: '500 grams',
    quantity: 1000, rate: 3, 
  ),
  Product(
    name:"Apple",
    description: "The apple is a sweet fruit from the rose family.",
    image:"assets/img/fruits.png",
    price:1.5,
    category:"Fruits",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Banana",
    description: "The banana is a tropical fruit known for its sweetness.",
    image:"assets/img/fruits.png",
    price:1.0,
    category:"Fruits",
    weight: '500 grams',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Grapes",
    description: "Grapes are small, juicy fruits that grow in clusters.",
    image:"assets/img/fruits.png",
    price:2.0,
    category:"Fruits",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Pineapple",
    description: "Pineapple is a tropical fruit with a sweet and tangy flavor.",
    image:"assets/img/fruits.png",
    price:3.0,
    category:"Fruits",
    weight: '500 grams',
    quantity: 1000, rate: 5, 
  ),
];

final List<Product> vegetables = [
  Product(
    name:"Carrot",
    description: "Carrot is a root vegetable, usually orange in color.",
    image:"assets/img/vegetable.png",
    price:0.8,
    category:"Vegetables",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Potato",
    description: "Potato is a starchy vegetable commonly used in various dishes.",
    image:"assets/img/vegetable.png",
    price:1.0,
    category:"Vegetables",
    weight: '500 grams',
    quantity: 1000, rate: 3, 
  ),
  Product(
    name:"Tomato",
    description: "Tomato is a red, juicy fruit often used as a vegetable in cooking.",
    image:"assets/img/vegetable.png",
    price:1.2,
    category:"Vegetables",
    weight: '500 grams',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Cucumber",
    description: "Cucumber is a refreshing vegetable with a mild flavor.",
    image:"assets/img/vegetable.png",
    price:1.5,
    category:"Vegetables",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Lettuce",
    description: "Lettuce is a leafy green vegetable commonly used in salads.",
    image:"assets/img/vegetable.png",
    price:1.0,
    category:"Vegetables",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
];

final List<Product> milkAndEggs = [
  Product(
    name:"Milk",
    description: "Milk is a dairy product rich in calcium and vitamins.",
    image:"assets/img/milkegg.png",
    price:1.0,
    category:"Milk & Eggs",
    weight: '1 liter',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Eggs",
    description: "Eggs are a high-protein food product from hens.",
    image:"assets/img/milkegg.png",
    price:2.0,
    category:"Milk & Eggs",
    weight: '12 pieces',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Butter",
    description: "Butter is a dairy product made from churned cream.",
    image:"assets/img/milkegg.png",
    price:3.0,
    category:"Milk & Eggs",
    weight: '250 grams',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Cheese",
    description: "Cheese is a dairy product made from milk through curdling.",
    image:"assets/img/milkegg.png",
    price:4.0,
    category:"Milk & Eggs",
    weight: '200 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Yogurt",
    description: "Yogurt is a dairy product made by fermenting milk with bacteria.",
    image:"assets/img/milkegg.png",
    price:1.5,
    category:"Milk & Eggs",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
];

final List<Product> meat = [
  Product(
    name:"Chicken Breast",
    description: "Chicken breast is a lean and versatile meat.",
    image:"assets/img/meat.png",
    price:5.0,
    category:"Meat",
    weight: '500 grams',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Beef Steak",
    description: "Beef steak is a tender and flavorful cut of meat.",
    image:"assets/img/meat.png",
    price:7.0,
    category:"Meat",
    weight: '500 grams',
    quantity: 1000, rate: 5, 
  ),
  Product(
    name:"Chicken", 
    description: "Chicken is a versatile meat rich in protein.",
    image:"assets/img/meat.png",
    price:6.0,
    category:"Meat",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
  Product(
    name:"Lamb Leg", 
    description: "Lamb leg is a tender and flavorful meat from young sheep.",
    image:"assets/img/meat.png",
    price:8.0,
    category:"Meat",
    weight: '500 grams',
    quantity: 1000, rate: 4, 
  ),
];
