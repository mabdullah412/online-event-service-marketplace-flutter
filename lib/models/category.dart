class Category {
  final String id;
  final String title;
  final String description;
  final String imageLocation;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.imageLocation,
  });

  static Category fromJson(json) => Category(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageLocation: json['imageLocation'],
      );
}

final List<Category> allCategories = [
  Category(
    id: 'cat001',
    title: 'Decoration',
    description: 'Decoration related services',
    imageLocation: 'assets/icons/categories/decoration.png',
  ),
  Category(
    id: 'cat002',
    title: 'Car Rental',
    description: 'Car renting related services',
    imageLocation: 'assets/icons/categories/car_rental.png',
  ),
  Category(
    id: 'cat003',
    title: 'Catering',
    description: 'Catering related services',
    imageLocation: 'assets/icons/categories/catering.png',
  ),
  Category(
    id: 'cat004',
    title: 'Halls',
    description: 'Halls renting related services',
    imageLocation: 'assets/icons/categories/halls.png',
  ),
  Category(
    id: 'cat005',
    title: 'Dressing',
    description: 'Dress renting related services',
    imageLocation: 'assets/icons/categories/car_rental.png',
  ),
  Category(
    id: 'cat006',
    title: 'Photography',
    description: 'Photography related services',
    imageLocation: 'assets/icons/categories/photography.png',
  ),
];
