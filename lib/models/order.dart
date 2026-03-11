/// An item in a past order.
class OrderItem {
  final String name;
  final String image;
  final int qty;
  final double rate;

  double get amount => qty * rate;

  const OrderItem({
    required this.name,
    required this.image,
    required this.qty,
    required this.rate,
  });
}

/// A completed/past order record.
class Order {
  final String id;
  final String date;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double grandTotal;
  final String status;
  final String cashier;
  final String counter;
  final String paymentMode;
  final int buzzPoints;

  const Order({
    required this.id,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.status,
    this.cashier = 'Suraj Giri',
    this.counter = 'POS12',
    this.paymentMode = 'cash',
    this.buzzPoints = 0,
  });
}
