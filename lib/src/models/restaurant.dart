class Restaurant {
  String id;
  String name;
  String description;
  int rate;
  String address;
  String image;
  String phone;
  String mobile;
  String information;
  List<String> gallery = [
    'img/intro/intro_4.png',
    'img/intro/intro_5.png',
    'img/intro/intro_3.png',
    'img/intro/intro_1.png',
    'img/intro/intro_2.png',
  ];
  double lat = 37.42;
  double lon = -122.08;

  Restaurant(
      this.id, this.name, this.description, this.rate, this.address, this.image, this.phone, this.mobile, this.information, this.lat, this.lon);
}

class RestaurantsList {
  List<Restaurant>? _restaurantsList;

  List<Restaurant>? _popularRestaurantsList;

  List<Restaurant>? get popularRestaurantsList => _popularRestaurantsList;
  List<Restaurant>? get restaurantsList => _restaurantsList;

  RestaurantsList() {
    // this._restaurantsList = [
    //   new Restaurant(
    //       'rest0',
    //       'Party Fowl',
    //       'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    //       3,
    //       'Aldus PageMaker including versions of Lorem Ipsum',
    //       'img/intro/intro_1.png',
    //       '+136 226 5669',
    //       '+163 525 9432',
    //       'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 9:00AM',
    //       37.42796133580664,
    //       -122.085749655962),
    //   new Restaurant(
    //       'rest1',
    //       'The Dairy Miralova',
    //       'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    //       4,
    //       'Aldus PageMaker including versions of Lorem Ipsum',
    //       'img/intro/intro_2.png',
    //       '+136 226 5669',
    //       '+163 525 9432',
    //       'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
    //       37.42196133580664,
    //       -122.086749655962),
    //   new Restaurant(
    //       'rest2',
    //       'Nacho Problem',
    //       'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    //       5,
    //       'Aldus PageMaker including versions of Lorem Ipsum',
    //       'img/intro/intro_3.png',
    //       '+136 226 5669',
    //       '+163 525 9432',
    //       'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
    //       37.4226133580664,
    //       -122.086759655962),
    //   new Restaurant(
    //       'rest3',
    //       'Wok N\' Roll',
    //       'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    //       2,
    //       'Aldus PageMaker including versions of Lorem Ipsum',
    //       'img/intro/intro_4.png',
    //       '+136 226 5669',
    //       '+163 525 9432',
    //       'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
    //       37.42736133580664,
    //       -122.086750655962),
    //   new Restaurant(
    //       'rest4',
    //       'Traditional Restaurant',
    //       'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    //       5,
    //       'Aldus PageMaker including versions of Lorem Ipsum',
    //       'img/intro/intro_5.png',
    //       '+136 226 5669',
    //       '+163 525 9432',
    //       'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
    //       37.42790133580664,
    //       -122.086760655962),
    // ];

    this._popularRestaurantsList = [
      new Restaurant(
          'rest1',
          'Buy directly from 1000s of Neighborhood stores',
          'You can buy directly from your local businesses in and around you, send them a list of products you need and choose pick up or delivery options.',
          4,
          'Aldus PageMaker including versions of Lorem Ipsum',
          'img/intro/intro_4.png',
          '+136 226 5669',
          '+163 525 9432',
          'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
          37.157,
          -122.086748055962),
      new Restaurant(
          'rest2',
          'Look for service providers to fulfill your requirements',
          'Order the services you need from service professionals in and around you. You can send them a list of services you need with a service date of when you want them to serve you.',
          5,
          'Aldus PageMaker including versions of Lorem Ipsum',
          'img/intro/intro_5.png',
          '+136 226 5669',
          '+163 525 9432',
          'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
          37.4585,
          -122.37574),
      new Restaurant(
          'rest3',
          'Reverse auction & Bargain',
          'No need to roam around different stores for your needs, let them come to you with their offer. Post a request about the products or services you need and the store representatives in and around you dealing with that category of products or services will get notified to provide you with a better price.\n\nChoose a product or service you want to request to bargain and make an offer for it.',
          2,
          'Aldus PageMaker including versions of Lorem Ipsum',
          'img/intro/intro_1.png',
          '+136 226 5669',
          '+163 525 9432',
          'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
          37.457,
          -122.56785),
      new Restaurant(
          'rest4',
          'Chat with businesses directly. Order with confidence',
          'You can chat with the businesses directly for any questions you may have or to place an order with confidence. ',
          5,
          'Aldus PageMaker including versions of Lorem Ipsum',
          'img/intro/intro_2.png',
          '+136 226 5669',
          '+163 525 9432',
          'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
          37.68578,
          -122.458),
      new Restaurant(
          'rest4',
          'Discover a wide variety of categories',
          'TradeMantri has businesses in various categories, you can order whatever you need at the comfort of your home.',
          5,
          'Aldus PageMaker including versions of Lorem Ipsum',
          'img/intro/intro_3.png',
          '+136 226 5669',
          '+163 525 9432',
          'Monday - Thursday    10:00AM - 11:00PM' + '\nFriday - Sunday    12:00PM - 5:00AM',
          37.68578,
          -122.458),
    ];
  }
}
