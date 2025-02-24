import 'package:flutter/material.dart';
import 'package:mkadia/models/order.dart';
import 'package:mkadia/models/user.dart';
import 'package:mkadia/provider/BottomNavProvider.dart';
import 'package:mkadia/views/Delivery/ConfirmationPage.dart';
import 'package:mkadia/views/Delivery/TrackingPage.dart';
import 'package:mkadia/views/home/HomeView.dart';
import 'package:mkadia/views/ConfirmationOrder/OrderConfirmationPage.dart';
import 'package:mkadia/views/profil/profil.dart';
import 'package:provider/provider.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> get views => [
        const HomeView(),
        _buildDeliveryNavigator(), // Index 1
        ProfilPage(user: users[0]), // Index 2
      ];

  @override
  Widget build(BuildContext context) {
    // Écouter les changements du BottomNavProvider
    final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: true);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          // Mettre à jour l'index dans le BottomNavProvider
          bottomNavProvider.setCurrentIndex(index);
        },
        indicatorColor: Colors.amber,
        selectedIndex: bottomNavProvider.currentIndex, // Utiliser l'index du Provider
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_shipping),
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Delivery',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: bottomNavProvider.currentIndex, // Utiliser l'index du Provider
        children: views,
      ),
    );
  }

  Widget _buildDeliveryNavigator() {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/deliveryTracking':
                return const DeliveryTrackingPage();
              case '/deliveryConfirmation':
                final order = settings.arguments as Order;
                return DeliveryConfirmationPage(order: order);
              default:
                return const OrderConfirmationPage(); // Page par défaut
            }
          },
        );
      },
    );
  }
}