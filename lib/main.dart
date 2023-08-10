import 'package:flutter/material.dart';
import 'package:restourant_/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Restorant',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        DetailPage.routeName: (context) => DetailPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/local_restaurant.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Restaurants> restaurants =
                parseRestaurant(snapshot.data!);
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, restaurants[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurants restaurant) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName,
            arguments: restaurant);
      },
      leading: Image.network(
        restaurant.pictureId,
        width: 100,
        errorBuilder: (ctx, error, _) =>
            const Center(child: Icon(Icons.error)),
      ),
      title: Text(restaurant.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_pin),
              Text(restaurant.city),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(restaurant.rating.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  static const routeName = '/detail_page';

  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)?.settings.arguments as Restaurants;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: SingleChildScrollView(
        child: Hero(
          tag: restaurant.pictureId,
          child: Column(
            children: [
              Image.network(restaurant.pictureId),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin),
                              Text(restaurant.city),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(restaurant.rating.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    const Text('Description'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      restaurant.description,
                      overflow: TextOverflow.clip,
                    ),
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Menus:'),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Foods:'),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: restaurant.menus.foods.length,
                                itemBuilder: (context, index) {
                                  final food = restaurant.menus.foods[index];
                                  return ListTile(
                                    leading: Icon(Icons.restaurant_menu),
                                    title: Text(food.name),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text('Drinks:'),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: restaurant.menus.drinks.length,
                                itemBuilder: (context, index) {
                                  final drink = restaurant.menus.drinks[index];
                                  return ListTile(
                                    leading: Icon(Icons.local_cafe),
                                    title: Text(drink.name),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
