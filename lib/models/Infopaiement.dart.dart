class PaymentInfo {
  String cardNumber;
  String expiryDate;
  String cvv;
  String name;
  String address;
  String city;
  String country;

  PaymentInfo({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
  });

  static List<PaymentInfo> examplePayments() {
    return [
      PaymentInfo(
        cardNumber: '1234567812345678',
        expiryDate: '12/25',
        cvv: '123',
        name: 'John Doe',
        address: '123 Main Street',
        city: 'Paris',
        country: 'France',
      ),
      PaymentInfo(
        cardNumber: '8765432187654321',
        expiryDate: '06/24',
        cvv: '456',
        name: 'Jane Smith',
        address: '456 Elm Street',
        city: 'Lyon',
        country: 'France',
      ),
    ];
  }
}