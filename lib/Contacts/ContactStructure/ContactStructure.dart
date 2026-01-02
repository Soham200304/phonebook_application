class ContactStructure {
  final String id;
  final String name;
  final String phone;

  ContactStructure({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory ContactStructure.fromFirestore(
      String id, Map<String, dynamic> data) {
    return ContactStructure(
      id: id,
      name: data['name'],
      phone: data['phone_no'],
    );
  }
}
