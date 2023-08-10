import 'dart:convert';

class Restaurants {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final Menus menus;

  Restaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory Restaurants.fromJson(Map<String, dynamic> restaurant) => Restaurants(
        id: restaurant["id"],
        name: restaurant["name"],
        description: restaurant["description"],
        pictureId: restaurant["pictureId"],
        city: restaurant["city"],
        rating: restaurant["rating"]?.toDouble(),
        menus: Menus.fromJson(restaurant["menus"]),
      );
}

class Menus {
  List<Drink> foods;
  List<Drink> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> menu) => Menus(
        foods: List<Drink>.from(menu["foods"].map((x) => Drink.fromJson(x))),
        drinks: List<Drink>.from(menu["drinks"].map((x) => Drink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class Drink {
  Drink({
    required this.name,
  });
  String name;

  factory Drink.fromJson(Map<String, dynamic> drinkk) => Drink(
        name: drinkk["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

List<Restaurants> parseRestaurant(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);

  final List<Restaurants> listRestaurant = [];

  parsed['restaurants'].forEach((restaurant) {
    listRestaurant.add(Restaurants.fromJson(restaurant));
  });

  return listRestaurant;
}