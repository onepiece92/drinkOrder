import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/address.dart';

/// All static data for the Liquid Gold app.
abstract final class DrinksData {
  static const List<Category> categories = [
    Category(id: 'whiskey', label: 'Whiskey', icon: '🥃', count: 24),
    Category(id: 'wine', label: 'Wine', icon: '🍷', count: 42),
    Category(id: 'gin', label: 'Gin', icon: '🍸', count: 18),
    Category(id: 'vodka', label: 'Vodka', icon: '🧊', count: 15),
    Category(id: 'tequila', label: 'Tequila', icon: '🌵', count: 12),
  ];

  static const List<Product> products = [
    Product(
      id: 1,
      name: 'Macallan 18Y',
      sub: 'Sherry Oak Highland Single Malt',
      category: 'whiskey',
      price: 350.00,
      vol: '750ml',
      abv: '43%',
      age: '18Y',
      rating: 4.9,
      reviews: 450,
      image: '🥃',
      badge: 'Rare Find',
      description:
          'A classic Highland single malt, matured for 18 years in Sherry oak casks from Jerez, Spain.',
      tags: ['Single Malt', 'Sherry Oak'],
      time: 'In Stock',
    ),
    Product(
      id: 2,
      name: 'Dom Pérignon 2012',
      sub: 'Vintage Brut Champagne',
      category: 'wine',
      price: 245.00,
      vol: '750ml',
      abv: '12.5%',
      age: '2012',
      rating: 5.0,
      reviews: 128,
      image: '🍾',
      badge: 'Vintage',
      description:
          'Explosive yet balanced, this vintage Champagne is a masterpiece of precision and intensity.',
      tags: ['Champagne', 'Sparkling'],
      time: 'Limited',
    ),
    Product(
      id: 3,
      name: 'Hendrick\'s Gin',
      sub: 'Small Batch Infused Gin',
      category: 'gin',
      price: 45.00,
      vol: '700ml',
      abv: '44%',
      age: 'NAS',
      rating: 4.8,
      reviews: 860,
      image: '🍸',
      badge: 'Bestseller',
      description:
          'Infused with cucumber and rose, this gin is uniquely refreshing and wonderfully odd.',
      tags: ['Premium', 'Cucumber'],
      time: 'In Stock',
    ),
    Product(
      id: 4,
      name: 'Clase Azul Reposado',
      sub: '100% Blue Agave Tequila',
      category: 'tequila',
      price: 189.00,
      vol: '750ml',
      abv: '40%',
      age: 'Reposado',
      rating: 4.9,
      reviews: 215,
      image: '🌵',
      badge: 'Artisanal',
      description:
          'Slow-cooked Blue Agave tequila presented in a beautiful handcrafted ceramic decanter.',
      tags: ['Ultra Premium', 'Reposado'],
      time: 'Only 3 left',
    ),
    Product(
      id: 5,
      name: 'Grey Goose Vodka',
      sub: 'French Premium Vodka',
      category: 'vodka',
      price: 55.00,
      vol: '1.0L',
      abv: '40%',
      age: 'NAS',
      rating: 4.7,
      reviews: 1200,
      image: '🧊',
      badge: null,
      description:
          'Distilled in France using soft winter wheat and limestone-filtered spring water.',
      tags: ['Smooth', 'French'],
      time: 'In Stock',
    ),
    Product(
      id: 6,
      name: 'Yamazaki 12Y',
      sub: 'Japanese Single Malt Whiskey',
      category: 'whiskey',
      price: 210.00,
      vol: '700ml',
      abv: '43%',
      age: '12Y',
      rating: 4.9,
      reviews: 340,
      image: '🥃',
      badge: 'Japanese',
      description:
          'Suntory\'s flagship single malt, known for its multi-layered aroma with fruit and Mizunara notes.',
      tags: ['Single Malt', 'Imported'],
      time: 'Sold Out',
    ),
  ];

  static const List<Order> recentOrders = [
    Order(
      id: '#LG-8241',
      date: 'Today, 6:45 PM',
      items: [
        OrderItem(name: 'Hendrick\'s Gin', image: '🍸', qty: 1),
        OrderItem(name: 'Macallan 18Y', image: '🥃', qty: 1),
      ],
      total: 395.00,
      status: 'Out for Delivery',
    ),
    Order(
      id: '#LG-8210',
      date: 'Yesterday, 2:15 PM',
      items: [OrderItem(name: 'Grey Goose Vodka', image: '🧊', qty: 2)],
      total: 110.00,
      status: 'Delivered',
    ),
  ];

  static const List<Address> savedAddresses = [
    Address(
      id: 1,
      label: 'Home',
      address: '742 Evergreen Terrace, Springfield',
      icon: '🏠',
      type: 'Delivery',
    ),
    Address(
      id: 2,
      label: 'Penthouse',
      address: '1 Central Park West, New York',
      icon: '🏢',
      type: 'Delivery',
    ),
  ];
  static const List<String> preferenceOptions = [
    'Single Malt',
    'Peated',
    'Oak Matured',
    'Dry',
    'Botanical',
    'Full Bodied'
  ];
}
