// ============================================================
//  app_models.dart — Unified data layer for Zinko
//  All screens share this single source of truth.
// ============================================================

import 'package:flutter/material.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';

// ─────────────────────────────────────────────────────────────
//  ENUMS
// ─────────────────────────────────────────────────────────────

enum PlaceType { cafe, coworking, office, event }

enum EntityType { place, person, event }

// ─────────────────────────────────────────────────────────────
//  ZINKO PLACE  (Café / Coworking / Office)
// ─────────────────────────────────────────────────────────────

class ZinkoPlace {
  final String id;
  final String name;
  final String location;
  final String distance;
  final double rating;
  final String price;
  final String priceUnit;
  final String imageUrl;
  final List<IconData> amenities;
  final List<String> amenityNames;
  final List<String> perkTags;
  final String description;
  final int tablesLeft;
  final int totalSlots;
  final String? discount;
  final String? discountDesc;
  final String? promoCode;
  final PlaceType type;
  bool isFavorite;
  bool isBookmarked;
  bool isBooked;
  final double lat;
  final double lng;
  final List<ZinkoReview> reviews;

  ZinkoPlace({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.price,
    required this.priceUnit,
    required this.imageUrl,
    required this.amenities,
    required this.amenityNames,
    required this.perkTags,
    required this.description,
    required this.tablesLeft,
    required this.totalSlots,
    this.discount,
    this.discountDesc,
    this.promoCode,
    this.type = PlaceType.cafe,
    this.isFavorite = false,
    this.isBookmarked = false,
    this.isBooked = false,
    this.lat = 51.5074,
    this.lng = -0.1278,
    this.reviews = const [],
  });

  String get category => type.name; // backward compat
  String get imageUrl_ => imageUrl;
}

// ─────────────────────────────────────────────────────────────
//  ZINKO PERSON  (Member on map / community)
// ─────────────────────────────────────────────────────────────

class ZinkoPerson extends PersonEntity {
  ZinkoPerson({
    required super.id,
    required super.name,
    required super.role,
    required super.bio,
    required super.avatarUrl,
    required super.location,
    super.connections,
    super.groups,
    super.rating,
    super.skills,
    super.isVerified,
    super.lat,
    super.lng,
    super.isConnected,
    super.isFavorite,
  });
}

// ─────────────────────────────────────────────────────────────
//  ZINKO EVENT
// ─────────────────────────────────────────────────────────────

class ZinkoEvent {
  final String id;
  final String title;
  final String category;
  final String date;
  final String month;
  final String location;
  final String price;
  final String hostName;
  final String hostImage;
  final String imageUrl;
  final String description;
  final bool isPremiumOnly;
  final int attendees;
  bool isFavorite;
  bool isRegistered;

  ZinkoEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.month,
    required this.location,
    required this.price,
    required this.hostName,
    required this.hostImage,
    required this.imageUrl,
    this.description = '',
    this.isPremiumOnly = false,
    this.attendees = 0,
    this.isFavorite = false,
    this.isRegistered = false,
  });
}

// ─────────────────────────────────────────────────────────────
//  ZINKO REVIEW
// ─────────────────────────────────────────────────────────────

class ZinkoReview {
  final String userName;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String timeAgo;

  const ZinkoReview({
    required this.userName,
    required this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}

// ─────────────────────────────────────────────────────────────
//  BOOKING
// ─────────────────────────────────────────────────────────────

class ZinkoBooking {
  final String id;
  final String placeId;
  final String placeName;
  final String location;
  final String imageUrl;
  final DateTime date;
  final String timeSlot;
  final String tableNumber;
  final double subtotal;
  final double tax;
  final double total;
  final bool isCompleted;
  final PlaceType placeType;

  ZinkoBooking({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.location,
    required this.imageUrl,
    required this.date,
    required this.timeSlot,
    required this.tableNumber,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.isCompleted = false,
    this.placeType = PlaceType.cafe,
  });
}

// ─────────────────────────────────────────────────────────────
//  CHAT / POST / GROUP / CONNECTION
// ─────────────────────────────────────────────────────────────

class ZinkoChat {
  final String id;
  final String name;
  String lastMessage;
  final String time;
  final String avatar;
  int unreadCount;
  final bool isOnline;
  final bool isPremiumLocked;

  ZinkoChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.unreadCount,
    required this.isOnline,
    this.isPremiumLocked = false,
  });
}

class ZinkoPost {
  final String id;
  final String userName;
  final String userRole;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? postImage;
  int likes;
  int comments;
  bool isLiked;

  ZinkoPost({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.postImage,
    required this.likes,
    required this.comments,
    this.isLiked = false,
  });
}

class ZinkoGroup {
  final String id;
  final String name;
  final String memberCount;
  final String image;
  bool isJoined;

  ZinkoGroup({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.image,
    this.isJoined = false,
  });
}

class ZinkoConnection {
  final String id;
  final String name;
  final String role;
  final String avatar;
  bool isConnected;

  ZinkoConnection({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
    this.isConnected = false,
  });
}

// ─────────────────────────────────────────────────────────────
//  SAMPLE DATA — PLACES
// ─────────────────────────────────────────────────────────────

final List<ZinkoPlace> kAllPlaces = [
  ZinkoPlace(
    id: 'p1',
    name: 'Cafe Work',
    location: 'Canary Wharf, London',
    distance: '8.0 km away',
    rating: 4.5,
    price: '£5',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
    amenities: [
      Icons.wifi,
      Icons.coffee_outlined,
      Icons.restaurant,
      Icons.power
    ],
    amenityNames: ['WiFi', 'Coffee', 'Food', 'Power Sockets'],
    perkTags: ['10% off on Food', 'Unlimited Refills'],
    description:
        'Work from a cozy cafe with artisanal coffee and quiet corners. Ideal for writers and solo founders.',
    tablesLeft: 8,
    totalSlots: 15,
    discount: '20% OFF',
    discountDesc: 'On all beverages',
    promoCode: 'Code: CAFE20',
    type: PlaceType.cafe,
    lat: 51.5033,
    lng: -0.0195,
    reviews: [
      ZinkoReview(
          userName: 'Alice M.',
          avatarUrl: 'https://i.pravatar.cc/60?u=a1',
          rating: 5.0,
          comment: 'Love this place, great WiFi and vibes!',
          timeAgo: '2 days ago'),
      ZinkoReview(
          userName: 'Bob K.',
          avatarUrl: 'https://i.pravatar.cc/60?u=a2',
          rating: 4.0,
          comment: 'Good coffee. A bit loud on weekdays.',
          timeAgo: '1 week ago'),
    ],
  ),
  ZinkoPlace(
    id: 'p2',
    name: 'Bohemian Brew',
    location: 'Notting Hill, London',
    distance: '3.2 km away',
    rating: 4.4,
    price: '£6',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.restaurant],
    amenityNames: ['WiFi', 'Coffee', 'Food'],
    perkTags: ['Free Cookie', 'Quiet Zones'],
    description:
        'A vibrant space with quirky decor and the best sourdough toast in London.',
    tablesLeft: 5,
    totalSlots: 12,
    // discount: '15% OFF',
    // discountDesc: 'On workspace booking',
    promoCode: 'Code: BREW15',
    type: PlaceType.cafe,
    lat: 51.5151,
    lng: -0.2013,
    reviews: [
      ZinkoReview(
          userName: 'Emma R.',
          avatarUrl: 'https://i.pravatar.cc/60?u=e1',
          rating: 4.5,
          comment:
              'Cozy atmosphere and excellent coffee. Perfect for afternoon work sessions.',
          timeAgo: '1 week ago'),
      ZinkoReview(
          userName: 'Tom H.',
          avatarUrl: 'https://i.pravatar.cc/60?u=t1',
          rating: 4.0,
          comment: 'Great spot but can get busy during lunch hours.',
          timeAgo: '2 weeks ago'),
    ],
  ),
  ZinkoPlace(
    id: 'p3',
    name: 'The Reading Room',
    location: 'Bloomsbury, London',
    distance: '1.8 km away',
    rating: 4.5,
    price: '£5',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.book],
    amenityNames: ['WiFi', 'Library'],
    perkTags: ['Silence Guaranteed', 'Free Tea'],
    description:
        'Perfect for deep work. Library-style cafe offering complete silence and high-speed internet.',
    tablesLeft: 3,
    totalSlots: 20,
    type: PlaceType.cafe,
    lat: 51.5220,
    lng: -0.1260,
    isFavorite: true,
  ),
  ZinkoPlace(
    id: 'p4',
    name: 'Urban Hive',
    location: 'Shoreditch, London',
    distance: '1.2 km away',
    rating: 4.8,
    price: '£35',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.meeting_room_outlined],
    amenityNames: ['WiFi', 'Coffee', 'Meeting Rooms'],
    perkTags: ['Gym Access', 'Free Snacks'],
    description:
        'A modern coworking space in the heart of Shoreditch with rooftop access.',
    tablesLeft: 10,
    totalSlots: 50,
    type: PlaceType.coworking,
    lat: 51.5242,
    lng: -0.0763,
    reviews: [
      ZinkoReview(
          userName: 'Sarah P.',
          avatarUrl: 'https://i.pravatar.cc/60?u=s1',
          rating: 5.0,
          comment:
              'Amazing coworking space! The rooftop is perfect for breaks and the community is very welcoming.',
          timeAgo: '3 days ago'),
      ZinkoReview(
          userName: 'Mike D.',
          avatarUrl: 'https://i.pravatar.cc/60?u=m1',
          rating: 4.5,
          comment:
              'Great facilities and fast WiFi. The gym access is a nice bonus!',
          timeAgo: '5 days ago'),
      ZinkoReview(
          userName: 'Lisa W.',
          avatarUrl: 'https://i.pravatar.cc/60?u=l1',
          rating: 5.0,
          comment:
              'Best coworking space in Shoreditch. Love the vibe and the free snacks!',
          timeAgo: '1 week ago'),
    ],
  ),
  ZinkoPlace(
    id: 'p5',
    name: 'The Mill',
    location: 'Soho, London',
    distance: '3.5 km away',
    rating: 4.6,
    price: '£65',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.print, Icons.meeting_room],
    amenityNames: ['WiFi', 'Printing', 'Boardrooms'],
    perkTags: ['Networking Events', 'Private Booths'],
    description:
        'Industrial chic at its best. Premium offices and shared spaces for creatives.',
    tablesLeft: 2,
    totalSlots: 30,
    type: PlaceType.coworking,
    isFavorite: true,
    lat: 51.5138,
    lng: -0.1360,
  ),
  ZinkoPlace(
    id: 'p6',
    name: 'Code & Brew',
    location: 'Hackney, London',
    distance: '2.4 km away',
    rating: 4.3,
    price: '£7',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined],
    amenityNames: ['WiFi', 'Coffee'],
    perkTags: ['Developer Community', 'Hack Nights'],
    description:
        'Designed specifically for programmers. Dark mode aesthetic and very strong coffee.',
    tablesLeft: 6,
    totalSlots: 18,
    type: PlaceType.cafe,
    lat: 51.5450,
    lng: -0.0580,
  ),
  ZinkoPlace(
    id: 'p7',
    name: 'The Nook',
    location: 'Islington, London',
    distance: '0.9 km away',
    rating: 4.7,
    price: '£4',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.local_florist],
    amenityNames: ['WiFi', 'Coffee', 'Garden View'],
    perkTags: ['Pet Friendly', 'Free Parking'],
    description:
        'A cozy corner with lots of plants and a very relaxed atmosphere.',
    tablesLeft: 4,
    totalSlots: 10,
    type: PlaceType.cafe,
    lat: 51.5362,
    lng: -0.1030,
  ),
  ZinkoPlace(
    id: 'p8',
    name: 'WorkHub Central',
    location: 'Westminster, London',
    distance: '4.1 km away',
    rating: 4.2,
    price: '£45',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366412874-3415097a27e7?auto=format&fit=crop&w=800&q=80',
    amenities: [
      Icons.wifi,
      Icons.meeting_room_outlined,
      Icons.local_parking_outlined
    ],
    amenityNames: ['WiFi', 'Meetings', 'Valet Parking'],
    perkTags: ['Corporate Events', 'Concierge'],
    description:
        'Professional office space with premium amenities and excellent transport links.',
    tablesLeft: 5,
    totalSlots: 25,
    type: PlaceType.office,
    lat: 51.4980,
    lng: -0.1350,
  ),
  ZinkoPlace(
    id: 'p9',
    name: 'The Loft Studio',
    location: 'Hackney, London',
    distance: '2.8 km away',
    rating: 4.9,
    price: '£8',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.camera_alt_outlined, Icons.brush_outlined],
    amenityNames: ['WiFi', 'Studio Space', 'Art Supplies'],
    perkTags: ['Creative Community', 'Natural Light'],
    description:
        'A beautiful loft space for artists, photographers, and creative freelancers.',
    tablesLeft: 3,
    totalSlots: 8,
    type: PlaceType.coworking,
    lat: 51.5470,
    lng: -0.0570,
  ),
  ZinkoPlace(
    id: 'p10',
    name: 'Tech Hub London',
    location: 'Old Street, London',
    distance: '0.5 km away',
    rating: 4.7,
    price: '£40',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.meeting_room, Icons.power],
    amenityNames: ['WiFi', 'Tech Lab', 'VR Setup'],
    perkTags: ['VC Network', 'Pitch Nights'],
    description:
        'The go-to spot for tech startups. High-speed fiber and a community of innovators.',
    tablesLeft: 12,
    totalSlots: 60,
    type: PlaceType.coworking,
    lat: 51.5257,
    lng: -0.0875,
  ),
  // ZinkoPlace(
  //   id: 'p11',
  //   name: 'Zen Garden Cafe',
  //   location: 'Kensington, London',
  //   distance: '4.5 km away',
  //   rating: 4.6,
  //   price: '£6',
  //   priceUnit: '/hr',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1445116572660-23a0a880155b?auto=format&fit=crop&w=800&q=80',
  //   amenities: [Icons.wifi, Icons.grass_rounded, Icons.spa_outlined],
  //   amenityNames: ['WiFi', 'Outdoor Garden', 'Quiet Area'],
  //   perkTags: ['Free Herbal Tea', 'Yoga Breaks'],
  //   description:
  //       'A peaceful oasis in the city. Perfect for focused work without the noise.',
  //   tablesLeft: 4,
  //   totalSlots: 12,
  //   type: PlaceType.cafe,
  //   lat: 51.5014,
  //   lng: -0.1921,
  // ),
  ZinkoPlace(
    id: 'p12',
    name: 'The Glass House',
    location: 'London Bridge, London',
    distance: '0.2 km away',
    rating: 4.9,
    price: '£55',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.wb_sunny_outlined, Icons.meeting_room],
    amenityNames: ['High Speed WiFi', 'Natural Light', 'Private Office'],
    perkTags: ['Panoramic Views', 'Premium Coffee'],
    description:
        'A stunning all-glass coworking space with breathtaking views of the Shard and the City. Experience premium working environment.',
    tablesLeft: 5,
    totalSlots: 20,
    type: PlaceType.coworking,
    lat: 51.5079,
    lng: -0.0877,
    isFavorite: true,
    reviews: [
      ZinkoReview(
          userName: 'James T.',
          avatarUrl: 'https://i.pravatar.cc/60?u=j1',
          rating: 5.0,
          comment:
              'Absolutely stunning views! The natural light makes working here a pleasure. Worth every penny.',
          timeAgo: '2 days ago'),
      ZinkoReview(
          userName: 'Rachel M.',
          avatarUrl: 'https://i.pravatar.cc/60?u=r1',
          rating: 4.8,
          comment:
              'Premium space with excellent amenities. The coffee is top-notch and the atmosphere is very professional.',
          timeAgo: '4 days ago'),
    ],
  ),
  // ZinkoPlace(
  //   id: 'p13',
  //   name: 'Sky Garden Cafe',
  //   location: 'Fenchurch St, London',
  //   distance: '1.5 km away',
  //   rating: 4.8,
  //   price: '£8',
  //   priceUnit: '/hr',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1549416845-816790b4bf54?auto=format&fit=crop&w=800&q=80',
  //   amenities: [Icons.wifi, Icons.nature_people_outlined],
  //   amenityNames: ['WiFi', 'Gardens'],
  //   perkTags: ['Best View', 'Fresh Air'],
  //   description:
  //       'Work among the clouds. This rooftop garden cafe offers the most iconic views and a serene work environment.',
  //   tablesLeft: 4,
  //   totalSlots: 20,
  //   type: PlaceType.cafe,
  //   lat: 51.5113,
  //   lng: -0.0837,
  // ),
  ZinkoPlace(
    id: 'p14',
    name: 'The Brick House',
    location: 'Wapping, London',
    distance: '2.9 km away',
    rating: 4.4,
    price: '£40',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.meeting_room, Icons.local_cafe],
    amenityNames: ['Silent Rooms', 'Coffee'],
    perkTags: ['Quiet Zone', '24/7 Access'],
    description:
        'A converted warehouse turned modern office space. Exposed brick and industrial vibes for focus.',
    tablesLeft: 3,
    totalSlots: 15,
    type: PlaceType.office,
    lat: 51.5034,
    lng: -0.0573,
  ),
  ZinkoPlace(
    id: 'p15',
    name: 'Neon Work',
    location: 'Soho, London',
    distance: '3.8 km away',
    rating: 4.7,
    price: '£45',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.nightlife],
    amenityNames: ['WiFi', 'Late Night'],
    perkTags: ['Urban Vibes', 'DJ Set Fridays'],
    description:
        'Vibrant, neon-lit coworking space for the night owls and creative spirits.',
    tablesLeft: 12,
    totalSlots: 40,
    type: PlaceType.coworking,
    lat: 51.5123,
    lng: -0.1341,
  ),
  ZinkoPlace(
    id: 'p16',
    name: 'Riverside Cafe',
    location: 'Southbank, London',
    distance: '2.1 km away',
    rating: 4.6,
    price: '£6',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.water],
    amenityNames: ['WiFi', 'Coffee', 'River View'],
    perkTags: ['Outdoor Seating', 'Pet Friendly'],
    description:
        'Stunning riverside location with panoramic Thames views. Perfect for creative thinking.',
    tablesLeft: 7,
    totalSlots: 18,
    type: PlaceType.cafe,
    lat: 51.5081,
    lng: -0.1247,
  ),
  ZinkoPlace(
    id: 'p17',
    name: 'Innovation Lab',
    location: 'King\'s Cross, London',
    distance: '1.5 km away',
    rating: 4.9,
    price: '£50',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.science_outlined, Icons.meeting_room],
    amenityNames: ['High-Speed WiFi', 'Innovation Lab', 'Conference Rooms'],
    perkTags: ['Startup Mentorship', '3D Printing'],
    description:
        'State-of-the-art innovation hub with cutting-edge technology and maker spaces.',
    tablesLeft: 15,
    totalSlots: 45,
    type: PlaceType.coworking,
    lat: 51.5308,
    lng: -0.1238,
  ),
  ZinkoPlace(
    id: 'p18',
    name: 'The Green Room',
    location: 'Hampstead, London',
    distance: '5.2 km away',
    rating: 4.8,
    price: '£7',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.eco_outlined, Icons.local_florist],
    amenityNames: ['WiFi', 'Eco-Friendly', 'Garden'],
    perkTags: ['Organic Menu', 'Zero Waste'],
    description:
        'Eco-conscious cafe with a beautiful garden. Sustainable workspace for mindful professionals.',
    tablesLeft: 4,
    totalSlots: 10,
    type: PlaceType.cafe,
    lat: 51.5556,
    lng: -0.1778,
  ),
  ZinkoPlace(
    id: 'p19',
    name: 'Digital Nomad Hub',
    location: 'Covent Garden, London',
    distance: '2.7 km away',
    rating: 4.7,
    price: '£40',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.flight_outlined, Icons.language],
    amenityNames: ['Ultra-Fast WiFi', 'Travel Desk', 'Multi-Language'],
    perkTags: ['Global Community', 'Visa Support'],
    description:
        'Perfect for digital nomads and remote workers. International community and travel resources.',
    tablesLeft: 20,
    totalSlots: 55,
    type: PlaceType.coworking,
    lat: 51.5129,
    lng: -0.1243,
  ),
  ZinkoPlace(
    id: 'p20',
    name: 'Artisan Coffee House',
    location: 'Brixton, London',
    distance: '6.3 km away',
    rating: 4.5,
    price: '£5',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1453614512568-c4024d13c247?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.music_note],
    amenityNames: ['WiFi', 'Specialty Coffee', 'Live Music'],
    perkTags: ['Local Roasters', 'Art Gallery'],
    description:
        'Vibrant community cafe with locally roasted coffee and rotating art exhibitions.',
    tablesLeft: 6,
    totalSlots: 14,
    type: PlaceType.cafe,
    lat: 51.4613,
    lng: -0.1157,
  ),
  ZinkoPlace(
    id: 'p21',
    name: 'The Productivity Pod',
    location: 'Angel, London',
    distance: '1.9 km away',
    rating: 4.8,
    price: '£38',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.headphones, Icons.phone_in_talk],
    amenityNames: ['Ultra-Fast WiFi', 'Soundproof Booths', 'Phone Rooms'],
    perkTags: ['Focus Zones', 'Meditation Room'],
    description:
        'Designed for maximum productivity with soundproof pods and focus-enhancing environment.',
    tablesLeft: 8,
    totalSlots: 25,
    type: PlaceType.coworking,
    lat: 51.5327,
    lng: -0.1059,
  ),
  ZinkoPlace(
    id: 'p22',
    name: 'Espresso Express',
    location: 'Liverpool Street, London',
    distance: '1.1 km away',
    rating: 4.3,
    price: '£6',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.electrical_services],
    amenityNames: ['WiFi', 'Quick Service', 'Power Outlets'],
    perkTags: ['Fast WiFi', 'Express Menu'],
    description:
        'Perfect for quick work sessions. Fast service and reliable connectivity near the station.',
    tablesLeft: 10,
    totalSlots: 16,
    type: PlaceType.cafe,
    lat: 51.5178,
    lng: -0.0823,
  ),
  ZinkoPlace(
    id: 'p23',
    name: 'Creative Collective',
    location: 'Dalston, London',
    distance: '3.6 km away',
    rating: 4.9,
    price: '£42',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1531973576160-7125cd663d86?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.palette_outlined, Icons.camera_alt],
    amenityNames: ['WiFi', 'Art Studio', 'Photography Studio'],
    perkTags: ['Creative Workshops', 'Gallery Space'],
    description:
        'A haven for creatives with dedicated studio spaces, workshops, and collaborative areas.',
    tablesLeft: 6,
    totalSlots: 20,
    type: PlaceType.coworking,
    lat: 51.5461,
    lng: -0.0750,
    reviews: [
      ZinkoReview(
          userName: 'Alex P.',
          avatarUrl: 'https://i.pravatar.cc/60?u=alex1',
          rating: 5.0,
          comment:
              'Amazing creative space! The community here is incredibly supportive.',
          timeAgo: '1 week ago'),
    ],
  ),
  ZinkoPlace(
    id: 'p24',
    name: 'The Study Lounge',
    location: 'Holborn, London',
    distance: '2.3 km away',
    rating: 4.6,
    price: '£7',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.menu_book, Icons.local_library],
    amenityNames: ['WiFi', 'Library', 'Study Materials'],
    perkTags: ['Quiet Study', 'Free Books'],
    description:
        'Library-style workspace perfect for students and researchers. Extensive book collection.',
    tablesLeft: 12,
    totalSlots: 30,
    type: PlaceType.cafe,
    lat: 51.5174,
    lng: -0.1204,
  ),
  ZinkoPlace(
    id: 'p25',
    name: 'Startup Garage',
    location: 'Clerkenwell, London',
    distance: '1.7 km away',
    rating: 4.7,
    price: '£48',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.rocket_launch, Icons.groups],
    amenityNames: ['High-Speed WiFi', 'Pitch Room', 'Networking Events'],
    perkTags: ['Investor Network', 'Mentorship'],
    description:
        'Built for startups. Regular pitch events, investor connections, and mentorship programs.',
    tablesLeft: 15,
    totalSlots: 40,
    type: PlaceType.coworking,
    lat: 51.5236,
    lng: -0.1036,
  ),
  ZinkoPlace(
    id: 'p26',
    name: 'Brew & Build',
    location: 'Bethnal Green, London',
    distance: '3.1 km away',
    rating: 4.4,
    price: '£5',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.construction],
    amenityNames: ['WiFi', 'Coffee', 'Maker Space'],
    perkTags: ['DIY Tools', 'Workshop Area'],
    description:
        'Unique cafe with a maker space. Perfect for hardware hackers and DIY enthusiasts.',
    tablesLeft: 5,
    totalSlots: 12,
    type: PlaceType.cafe,
    lat: 51.5273,
    lng: -0.0552,
  ),
  ZinkoPlace(
    id: 'p27',
    name: 'The Executive Suite',
    location: 'Mayfair, London',
    distance: '3.9 km away',
    rating: 4.9,
    price: '£85',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.business_center, Icons.local_bar],
    amenityNames: ['Premium WiFi', 'Private Offices', 'Lounge Bar'],
    perkTags: ['Concierge Service', 'Valet Parking'],
    description:
        'Luxury coworking for executives. Premium amenities, private offices, and business lounge.',
    tablesLeft: 3,
    totalSlots: 15,
    type: PlaceType.office,
    lat: 51.5090,
    lng: -0.1419,
  ),
  ZinkoPlace(
    id: 'p28',
    name: 'Rooftop Workspace',
    location: 'Stratford, London',
    distance: '7.2 km away',
    rating: 4.8,
    price: '£35',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.wb_sunny, Icons.outdoor_grill],
    amenityNames: ['WiFi', 'Rooftop Terrace', 'BBQ Area'],
    perkTags: ['Outdoor Workspace', 'City Views'],
    description:
        'Work under the sky! Rooftop coworking with stunning city views and outdoor seating.',
    tablesLeft: 18,
    totalSlots: 35,
    type: PlaceType.coworking,
    lat: 51.5416,
    lng: -0.0037,
  ),
  ZinkoPlace(
    id: 'p29',
    name: 'The Quiet Corner',
    location: 'Marylebone, London',
    distance: '2.8 km away',
    rating: 4.7,
    price: '£8',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.volume_off, Icons.self_improvement],
    amenityNames: ['WiFi', 'Silent Zone', 'Meditation Space'],
    perkTags: ['No Talking', 'Zen Environment'],
    description:
        'Absolute silence guaranteed. Perfect for deep work, writing, and concentration.',
    tablesLeft: 4,
    totalSlots: 10,
    type: PlaceType.cafe,
    lat: 51.5225,
    lng: -0.1545,
  ),
  ZinkoPlace(
    id: 'p30',
    name: 'Tech Valley Hub',
    location: 'Whitechapel, London',
    distance: '4.5 km away',
    rating: 4.6,
    price: '£40',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.computer, Icons.developer_mode],
    amenityNames: ['Fiber Internet', 'Dev Tools', 'Server Room'],
    perkTags: ['Tech Talks', 'Hackathons'],
    description:
        'Tech-focused coworking with developer tools, server access, and regular tech events.',
    tablesLeft: 22,
    totalSlots: 50,
    type: PlaceType.coworking,
    lat: 51.5194,
    lng: -0.0608,
  ),
  ZinkoPlace(
    id: 'p31',
    name: 'Morning Glory Cafe',
    location: 'Clapham, London',
    distance: '5.8 km away',
    rating: 4.5,
    price: '£5',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.coffee_outlined, Icons.breakfast_dining],
    amenityNames: ['WiFi', 'Coffee', 'Breakfast Menu'],
    perkTags: ['Early Bird Special', 'Fresh Pastries'],
    description:
        'Perfect morning workspace with excellent breakfast options and fresh coffee.',
    tablesLeft: 8,
    totalSlots: 15,
    type: PlaceType.cafe,
    lat: 51.4618,
    lng: -0.1384,
  ),
  ZinkoPlace(
    id: 'p32',
    name: 'The Innovation Center',
    location: 'Canary Wharf, London',
    distance: '8.5 km away',
    rating: 4.9,
    price: '£60',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.science, Icons.lightbulb],
    amenityNames: ['Ultra-Fast WiFi', 'Innovation Lab', 'Prototyping'],
    perkTags: ['R&D Facilities', 'Patent Support'],
    description:
        'State-of-the-art innovation center with R&D labs and prototyping facilities.',
    tablesLeft: 10,
    totalSlots: 30,
    type: PlaceType.coworking,
    lat: 51.5054,
    lng: -0.0235,
    reviews: [
      ZinkoReview(
          userName: 'Dr. Sarah L.',
          avatarUrl: 'https://i.pravatar.cc/60?u=sarah2',
          rating: 5.0,
          comment:
              'Incredible facilities for innovation. The prototyping lab is world-class!',
          timeAgo: '3 days ago'),
    ],
  ),
  ZinkoPlace(
    id: 'p33',
    name: 'Bookworm Cafe',
    location: 'Charing Cross, London',
    distance: '2.0 km away',
    rating: 4.6,
    price: '£6',
    priceUnit: '/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.menu_book, Icons.coffee_outlined],
    amenityNames: ['WiFi', 'Book Exchange', 'Coffee'],
    perkTags: ['Reading Nooks', 'Book Club'],
    description:
        'Cozy cafe with extensive book collection. Perfect for readers and writers.',
    tablesLeft: 6,
    totalSlots: 12,
    type: PlaceType.cafe,
    discount: '10% OFF',
    discountDesc: 'Today Special',
    lat: 51.5080,
    lng: -0.1247,
  ),
  ZinkoPlace(
    id: 'p34',
    name: 'The Collaboration Space',
    location: 'Vauxhall, London',
    distance: '4.2 km away',
    rating: 4.7,
    price: '£38',
    priceUnit: '/day',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.groups_outlined, Icons.video_call],
    amenityNames: ['WiFi', 'Team Rooms', 'Video Conferencing'],
    perkTags: ['Whiteboard Walls', 'Brainstorm Rooms'],
    description:
        'Designed for team collaboration with flexible spaces and modern meeting technology.',
    tablesLeft: 12,
    totalSlots: 35,
    type: PlaceType.coworking,
    lat: 51.4861,
    lng: -0.1253,
    discount: '5% OFF',
    discountDesc: 'On Selected Food',
  ),
  ZinkoPlace(
    id: 'p35',
    name: 'Late Night Grind',
    location: 'Piccadilly, London',
    distance: '3.3 km away',
    rating: 4.4,
    price: '£7',
    priceUnit: '/hr',
    discount: '20% OFF',
    discountDesc: 'On all beverages',
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    amenities: [Icons.wifi, Icons.nightlight, Icons.coffee_outlined],
    amenityNames: ['WiFi', '24/7 Open', 'Strong Coffee'],
    perkTags: ['Night Owl Friendly', 'Late Night Menu'],
    description:
        'Open 24/7 for night owls and deadline chasers. Strong coffee and quiet atmosphere.',
    tablesLeft: 14,
    totalSlots: 20,
    type: PlaceType.cafe,
    lat: 51.5099,
    lng: -0.1337,
  ),
];

// ─────────────────────────────────────────────────────────────
//  SAMPLE DATA — PEOPLE
// ─────────────────────────────────────────────────────────────

final List<ZinkoPerson> kAllPeople = [
  ZinkoPerson(
    id: 'u1',
    name: 'Michael Chen',
    role: 'Full Stack Dev',
    bio:
        'Full Stack Developer with a passion for building scalable web applications.',
    avatarUrl: 'https://i.pravatar.cc/300?u=1',
    location: 'London, UK',
    connections: 220,
    rating: 4.8,
    skills: ['Flutter', 'React', 'NodeJS'],
    isVerified: true,
    lat: 51.5101,
    lng: -0.1303,
  ),
  ZinkoPerson(
    id: 'u2',
    name: 'Sophie Turner',
    role: 'UI/UX Designer',
    bio: 'Creative designer who loves crafting delightful experiences.',
    avatarUrl: 'https://i.pravatar.cc/300?u=2',
    location: 'Shoreditch, London',
    connections: 185,
    rating: 4.9,
    skills: ['Figma', 'Prototyping'],
    isVerified: true,
    lat: 51.5051,
    lng: -0.1103,
  ),
  ZinkoPerson(
    id: 'u3',
    name: 'James Watson',
    role: 'Product Manager',
    bio: 'PM at a Series B startup. Passionate about 0-to-1 products.',
    avatarUrl: 'https://i.pravatar.cc/300?u=3',
    location: 'Canary Wharf, London',
    connections: 310,
    rating: 4.7,
    skills: ['Roadmapping', 'Analytics'],
    isVerified: false,
    lat: 51.5181,
    lng: -0.1403,
  ),
  ZinkoPerson(
    id: 'u4',
    name: 'Emma Rodriguez',
    role: 'Graphic Designer',
    bio: 'Visual storyteller and illustrator. Love exploring vintage cafes.',
    avatarUrl: 'https://i.pravatar.cc/300?u=4',
    location: 'Notting Hill, London',
    connections: 150,
    rating: 4.9,
    skills: ['Illustration', 'Branding'],
    isVerified: true,
    lat: 51.5121,
    lng: -0.1903,
  ),
  ZinkoPerson(
    id: 'u5',
    name: 'David Wilson',
    role: 'iOS Developer',
    bio: 'Building the future of mobile. Swift & SwiftUI enthusiast.',
    avatarUrl: 'https://i.pravatar.cc/300?u=5',
    location: 'Westminster, London',
    connections: 420,
    rating: 4.8,
    skills: ['Swift', 'SwiftUI', 'Metal'],
    isVerified: true,
    lat: 51.5001,
    lng: -0.1203,
  ),
  ZinkoPerson(
    id: 'u6',
    name: 'Sarah Jenkins',
    role: 'Data Scientist',
    bio: 'ML Enthusiast. I love turning data into stories.',
    avatarUrl: 'https://i.pravatar.cc/300?u=6',
    location: 'Greenwich, London',
    skills: ['Python', 'SQL', 'PyTorch'],
    isVerified: true,
    lat: 51.4826,
    lng: 0.0077,
  ),
  ZinkoPerson(
    id: 'u7',
    name: 'Leo Maxwell',
    role: 'Mobile Dev',
    bio: 'Kotlin & Swift lover. Building smooth mobile experiences.',
    avatarUrl: 'https://i.pravatar.cc/300?u=7',
    location: 'Camden, London',
    skills: ['Kotlin', 'Swift'],
    lat: 51.5390,
    lng: -0.1426,
  ),
  ZinkoPerson(
    id: 'u8',
    name: 'Olivia Reed',
    role: 'UX Researcher',
    bio: 'Obsessed with human-centered design and usability.',
    avatarUrl: 'https://i.pravatar.cc/300?u=8',
    location: 'Fulham, London',
    skills: ['User Testing', 'Figma'],
    isVerified: true,
    lat: 51.4791,
    lng: -0.2074,
  ),
  ZinkoPerson(
    id: 'u9',
    name: 'Noah Bennett',
    role: 'Backend Architect',
    bio: 'Distributed systems and high-throughput APIs.',
    avatarUrl: 'https://i.pravatar.cc/300?u=9',
    location: 'Chelsea, London',
    skills: ['Go', 'Kubernetes', 'AWS'],
    lat: 51.4875,
    lng: -0.1682,
  ),
  ZinkoPerson(
    id: 'u10',
    name: 'Chloe Foster',
    role: 'Digital Marketer',
    bio: 'Growth hacker and SEO expert. Connecting brands with people.',
    avatarUrl: 'https://i.pravatar.cc/300?u=10',
    location: 'Ealing, London',
    skills: ['SEO', 'Google Ads'],
    lat: 51.5147,
    lng: -0.3015,
  ),
  ZinkoPerson(
    id: 'u11',
    name: 'Liam Carter',
    role: 'AI Researcher',
    bio: 'Deep learning for computer vision. Former PhD at UCL.',
    avatarUrl: 'https://i.pravatar.cc/300?u=11',
    location: 'Bloomsbury, London',
    skills: ['Python', 'OpenCV'],
    isVerified: true,
    lat: 51.5222,
    lng: -0.1308,
  ),
  ZinkoPerson(
    id: 'u12',
    name: 'Mia Thompson',
    role: 'DevOps Engineer',
    bio: 'Automation is my middle name. CI/CD wizard.',
    avatarUrl: 'https://i.pravatar.cc/300?u=12',
    location: 'Islingon, London',
    skills: ['Terraform', 'Docker'],
    lat: 51.5465,
    lng: -0.1058,
  ),
  ZinkoPerson(
    id: 'u13',
    name: 'Ryan Davies',
    role: 'Cybersecurity Analyst',
    bio: 'Protecting the web, one packet at a time.',
    avatarUrl: 'https://i.pravatar.cc/300?u=13',
    location: 'Wimbledon, London',
    skills: ['PenTesting', 'Networking'],
    lat: 51.4214,
    lng: -0.2055,
  ),
  ZinkoPerson(
    id: 'u14',
    name: 'Grace Bell',
    role: 'Motion Designer',
    bio: 'Bringing static designs to life with smooth animations.',
    avatarUrl: 'https://i.pravatar.cc/300?u=14',
    location: 'Richmond, London',
    skills: ['After Effects', 'Lottie'],
    lat: 51.4613,
    lng: -0.3033,
  ),
  ZinkoPerson(
    id: 'u15',
    name: 'William Scott',
    role: 'Entrepreneur',
    bio: 'Founder of multiple SaaS products. Always looking for talent.',
    avatarUrl: 'https://i.pravatar.cc/300?u=15',
    location: 'Mayfair, London',
    skills: ['SaaS', 'Venture Capital'],
    isVerified: true,
    lat: 51.5117,
    lng: -0.1472,
  ),
  ZinkoPerson(
    id: 'u16',
    name: 'Isabella Martinez',
    role: 'Content Creator',
    bio:
        'Digital content strategist and social media expert. Building brands online.',
    avatarUrl: 'https://i.pravatar.cc/300?u=16',
    location: 'Shoreditch, London',
    connections: 280,
    rating: 4.7,
    skills: ['Content Strategy', 'Social Media'],
    isVerified: true,
    lat: 51.5265,
    lng: -0.0782,
  ),
  ZinkoPerson(
    id: 'u17',
    name: 'Marcus Johnson',
    role: 'Blockchain Developer',
    bio:
        'Building the decentralized future. Smart contracts and DeFi enthusiast.',
    avatarUrl: 'https://i.pravatar.cc/300?u=17',
    location: 'Canary Wharf, London',
    connections: 195,
    rating: 4.8,
    skills: ['Solidity', 'Web3', 'Ethereum'],
    isVerified: true,
    lat: 51.5054,
    lng: -0.0235,
  ),
  ZinkoPerson(
    id: 'u18',
    name: 'Amelia Brown',
    role: 'HR Consultant',
    bio: 'Helping startups build amazing teams. People-first culture advocate.',
    avatarUrl: 'https://i.pravatar.cc/300?u=18',
    location: 'Westminster, London',
    connections: 340,
    rating: 4.9,
    skills: ['Recruitment', 'Culture Building'],
    isVerified: false,
    lat: 51.4995,
    lng: -0.1248,
  ),
  ZinkoPerson(
    id: 'u19',
    name: 'Daniel Kim',
    role: 'Game Developer',
    bio:
        'Creating immersive gaming experiences. Unity and Unreal Engine specialist.',
    avatarUrl: 'https://i.pravatar.cc/300?u=19',
    location: 'Soho, London',
    connections: 165,
    rating: 4.6,
    skills: ['Unity', 'C#', 'Game Design'],
    isVerified: true,
    lat: 51.5136,
    lng: -0.1359,
  ),
  ZinkoPerson(
    id: 'u20',
    name: 'Sophia Anderson',
    role: 'Legal Tech Advisor',
    bio:
        'Bridging law and technology. Helping startups navigate legal complexities.',
    avatarUrl: 'https://i.pravatar.cc/300?u=20',
    location: 'City of London',
    connections: 290,
    rating: 4.9,
    skills: ['Legal Tech', 'Compliance'],
    isVerified: true,
    lat: 51.5155,
    lng: -0.0922,
  ),
];

// ─────────────────────────────────────────────────────────────
//  SAMPLE DATA — EVENTS
// ─────────────────────────────────────────────────────────────

final List<ZinkoEvent> kAllEvents = [
  ZinkoEvent(
    id: 'e1',
    title: 'Startup Networking Night',
    category: 'Networking',
    date: '22',
    month: 'FEB',
    location: 'Urban Hive, Shoreditch',
    price: 'Free',
    hostName: 'Urban Hive',
    hostImage: 'UH',
    imageUrl:
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
    description: 'A monthly gathering of London\'s brightest startup founders.',
    attendees: 120,
  ),
  // ZinkoEvent(
  //   id: 'e2',
  //   title: 'Flutter Workshop: Animations',
  //   category: 'Workshop',
  //   date: '25',
  //   month: 'FEB',
  //   location: 'Cafe Work, Canary Wharf',
  //   price: '£15',
  //   hostName: 'Michael Chen',
  //   hostImage: 'https://i.pravatar.cc/300?u=1',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1540575861501-7c0011e7af7e?auto=format&fit=crop&w=800&q=80',
  //   description: 'Deep dive into Flutter animations with Michael Chen.',
  //   attendees: 45,
  // ),
  ZinkoEvent(
    id: 'e3',
    title: 'Digital Nomad Meetup',
    category: 'Social',
    date: '28',
    month: 'FEB',
    location: 'The Mill, Soho',
    price: 'Free',
    hostName: 'Zinko Community',
    hostImage: 'Z',
    imageUrl:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80',
    description: 'Connect with fellow digital nomads and remote workers.',
    attendees: 80,
  ),
  ZinkoEvent(
    id: 'e4',
    title: 'AI & Future of Work',
    category: 'Innovation',
    date: '05',
    month: 'MAR',
    location: 'The Glass House, London Bridge',
    price: '£25',
    hostName: 'Tech Innovators',
    hostImage: 'TI',
    imageUrl:
        'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&w=800&q=80',
    description:
        'Explore how AI is reshaping the corporate landscape and remote collaboration.',
    attendees: 55,
  ),
  ZinkoEvent(
    id: 'e5',
    title: 'Women in Tech Meetup',
    category: 'Social',
    date: '10',
    month: 'MAR',
    location: 'The Reading Room, Bloomsbury',
    price: 'Free',
    hostName: 'Olivia Reed',
    hostImage: 'https://i.pravatar.cc/300?u=8',
    imageUrl:
        'https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?auto=format&fit=crop&w=800&q=80',
    description:
        'Empowering women in the technology sector through mentorship and networking.',
    attendees: 40,
  ),
  ZinkoEvent(
    id: 'e6',
    title: 'Code Roast: Frontend Nightmares',
    category: 'Show',
    date: '12',
    month: 'MAR',
    location: 'Neon Work, Soho',
    price: '£10',
    hostName: 'Sophie Turner',
    hostImage: 'https://i.pravatar.cc/300?u=2',
    imageUrl:
        'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=800&q=80',
    description:
        'Laugh together as we roast the worst UI/UX design choices of the decade.',
    attendees: 30,
  ),
  ZinkoEvent(
    id: 'e7',
    title: 'Blockchain & Web3 Summit',
    category: 'Conference',
    date: '15',
    month: 'MAR',
    location: 'Sky Garden, London',
    price: '£50',
    hostName: 'Web3 London',
    hostImage: 'W3',
    imageUrl:
        'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&w=800&q=80',
    description:
        'Deep dive into decentralized technologies with industry leaders.',
    attendees: 200,
  ),
  ZinkoEvent(
    id: 'e8',
    title: 'London Coffee Lovers Meetup',
    category: 'Social',
    date: '18',
    month: 'MAR',
    location: 'Bohemian Brew, Notting Hill',
    price: 'Free',
    hostName: 'Emma Rodriguez',
    hostImage: 'https://i.pravatar.cc/300?u=4',
    imageUrl:
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=800&q=80',
    description: 'For those who love artisanal coffee and remote working.',
    attendees: 25,
  ),
  ZinkoEvent(
    id: 'e9',
    title: 'Hackathon: Green Cities',
    category: 'Competition',
    date: '22',
    month: 'MAR',
    location: 'Tech Hub London, Old Street',
    price: '£5',
    hostName: 'Tech Hub',
    hostImage: 'TH',
    imageUrl:
        'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
    description: 'Build solutions for a more sustainable urban future.',
    attendees: 100,
  ),
  ZinkoEvent(
    id: 'e10',
    title: 'Pitch Perfect: AI Startups',
    category: 'Innovation',
    date: '25',
    month: 'MAR',
    location: 'Metropolis Office, London',
    price: 'Free',
    hostName: 'David Wilson',
    hostImage: 'https://i.pravatar.cc/300?u=5',
    imageUrl:
        'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=800&q=80',
    description:
        'A platform for emerging AI startups to pitch their ideas to VCs.',
    attendees: 150,
  ),
  ZinkoEvent(
    id: 'e11',
    title: 'Yoga for Developers',
    category: 'Wellness',
    date: '28',
    month: 'MAR',
    location: 'Zen Garden Cafe, Kensington',
    price: '£5',
    hostName: 'Sarah Jenkins',
    hostImage: 'https://i.pravatar.cc/300?u=6',
    imageUrl:
        'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80',
    description:
        'Relax your mind and body with a morning yoga session tailored for devs.',
    attendees: 20,
  ),
  ZinkoEvent(
    id: 'e12',
    title: 'Game Dev Meetup',
    category: 'Social',
    date: '02',
    month: 'APR',
    location: 'Neon Work, Soho',
    price: 'Free',
    hostName: 'Leo Maxwell',
    hostImage: 'https://i.pravatar.cc/300?u=7',
    imageUrl:
        'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=800&q=80',
    description:
        'Share your latest builds and connect with fellow game developers.',
    attendees: 60,
  ),
  ZinkoEvent(
    id: 'e13',
    title: 'UI Design Deep Dive',
    category: 'Workshop',
    date: '05',
    month: 'APR',
    location: 'Artisan Hub, London',
    price: '£20',
    hostName: 'Sophie Turner',
    hostImage: 'https://i.pravatar.cc/300?u=2',
    imageUrl:
        'https://images.unsplash.com/photo-1558655146-d09347e92766?auto=format&fit=crop&w=800&q=80',
    description:
        'Learn advanced layout and typography techniques from an expert.',
    attendees: 35,
  ),
  ZinkoEvent(
    id: 'e14',
    title: 'Backend Security 101',
    category: 'Workshop',
    date: '08',
    month: 'APR',
    location: 'Code & Brew, Hackney',
    price: '£15',
    hostName: 'Ryan Davies',
    hostImage: 'https://i.pravatar.cc/300?u=13',
    imageUrl:
        'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80',
    description:
        'Understand the most common security vulnerabilities in backend APIs.',
    attendees: 40,
  ),
  ZinkoEvent(
    id: 'e15',
    title: 'Creative Writing Night',
    category: 'Arts',
    date: '10',
    month: 'APR',
    location: 'The Reading Room, Bloomsbury',
    price: 'Free',
    hostName: 'James Watson',
    hostImage: 'https://i.pravatar.cc/300?u=3',
    imageUrl:
        'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
    description:
        'Unleash your creativity with collaborative writing exercises.',
    attendees: 15,
  ),
  ZinkoEvent(
    id: 'e16',
    title: 'Fintech Innovation Summit',
    category: 'Conference',
    date: '15',
    month: 'APR',
    location: 'Canary Wharf, London',
    price: '£75',
    hostName: 'Financial Times',
    hostImage: 'FT',
    imageUrl:
        'https://images.unsplash.com/photo-1559136555-9303baea8ebd?auto=format&fit=crop&w=800&q=80',
    description:
        'Explore the future of finance with industry leaders and innovators.',
    attendees: 300,
  ),
  ZinkoEvent(
    id: 'e17',
    title: 'Photography Walk',
    category: 'Social',
    date: '18',
    month: 'APR',
    location: 'South Bank, London',
    price: 'Free',
    hostName: 'Grace Bell',
    hostImage: 'https://i.pravatar.cc/300?u=14',
    imageUrl:
        'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=800&q=80',
    description:
        'Capture the beauty of London with fellow photography enthusiasts.',
    attendees: 25,
  ),
  ZinkoEvent(
    id: 'e18',
    title: 'Sustainable Tech Forum',
    category: 'Innovation',
    date: '22',
    month: 'APR',
    location: 'The Green Room, Hampstead',
    price: '£20',
    hostName: 'Eco Tech Alliance',
    hostImage: 'ETA',
    imageUrl:
        'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=800&q=80',
    description:
        'Discussing technology solutions for environmental challenges.',
    attendees: 80,
  ),
  ZinkoEvent(
    id: 'e19',
    title: 'Freelancer Networking Brunch',
    category: 'Networking',
    date: '25',
    month: 'APR',
    location: 'Riverside Cafe, Southbank',
    price: '£15',
    hostName: 'Freelance London',
    hostImage: 'FL',
    imageUrl:
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=80',
    description:
        'Connect with fellow freelancers over brunch and share experiences.',
    attendees: 45,
  ),
  ZinkoEvent(
    id: 'e20',
    title: 'VR/AR Experience Night',
    category: 'Innovation',
    date: '28',
    month: 'APR',
    location: 'Innovation Lab, King\'s Cross',
    price: '£30',
    hostName: 'Daniel Kim',
    hostImage: 'https://i.pravatar.cc/300?u=19',
    imageUrl:
        'https://images.unsplash.com/photo-1617802690992-15d93263d3a9?auto=format&fit=crop&w=800&q=80',
    description:
        'Immerse yourself in the latest VR and AR technologies and demos.',
    attendees: 60,
  ),
];

// ─────────────────────────────────────────────────────────────
//  SAMPLE DATA — COMMUNITY
// ─────────────────────────────────────────────────────────────

final List<ZinkoPost> kAllPosts = [
  ZinkoPost(
    id: 'post1',
    userName: 'Sophie Turner',
    userRole: 'UX Designer',
    userAvatar: 'https://i.pravatar.cc/150?u=2',
    timeAgo: '2 hours ago',
    content:
        'Just discovered a great new spot in Shoreditch! "Urban Hive" is amazing.',
    postImage:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    likes: 24,
    comments: 5,
  ),
  ZinkoPost(
    id: 'post2',
    userName: 'Michael Chen',
    userRole: 'Full Stack Dev',
    userAvatar: 'https://i.pravatar.cc/150?u=1',
    timeAgo: '4 hours ago',
    content:
        'Can anyone recommend a quiet cafe near Westminster? Need to focus for a few hours.',
    likes: 12,
    comments: 8,
  ),
  ZinkoPost(
    id: 'post3',
    userName: 'Emma Rodriguez',
    userRole: 'Graphic Designer',
    userAvatar: 'https://i.pravatar.cc/150?u=4',
    timeAgo: '1 day ago',
    content:
        'Love the community here! Met some really talented designers today.',
    likes: 45,
    comments: 3,
  ),
  ZinkoPost(
    id: 'post4',
    userName: 'James Watson',
    userRole: 'Product Manager',
    userAvatar: 'https://i.pravatar.cc/300?u=3',
    timeAgo: '1 hour ago',
    content:
        'Who else is excited for the Web3 conference next month? Would love to meet up!',
    likes: 15,
    comments: 2,
  ),
  ZinkoPost(
    id: 'post5',
    userName: 'David Wilson',
    userRole: 'iOS Developer',
    userAvatar: 'https://i.pravatar.cc/300?u=5',
    timeAgo: '5 hours ago',
    content:
        'The new SwiftUI updates are a game changer. Bye bye UIKit (mostly).',
    likes: 89,
    comments: 14,
  ),
  ZinkoPost(
    id: 'post6',
    userName: 'Sarah Jenkins',
    userRole: 'Data Scientist',
    userAvatar: 'https://i.pravatar.cc/300?u=6',
    timeAgo: 'Yesterday',
    content:
        'Just published a medium article about "Ethics in AI". Link in bio!',
    likes: 56,
    comments: 9,
  ),
  ZinkoPost(
    id: 'post7',
    userName: 'Noah Bennett',
    userRole: 'Backend Architect',
    userAvatar: 'https://i.pravatar.cc/300?u=9',
    timeAgo: '2 days ago',
    content:
        'Is anyone else using Go for microservices? The concurrency model is fantastic.',
    likes: 42,
    comments: 7,
  ),
  ZinkoPost(
    id: 'post8',
    userName: 'Emma Rodriguez',
    userRole: 'Graphic Designer',
    userAvatar: 'https://i.pravatar.cc/300?u=4',
    timeAgo: '3 days ago',
    content: 'The lighting at Zen Garden Cafe is perfect for sketching today.',
    likes: 67,
    comments: 4,
  ),
  ZinkoPost(
    id: 'post9',
    userName: 'Chloe Foster',
    userRole: 'Marketer',
    userAvatar: 'https://i.pravatar.cc/300?u=10',
    timeAgo: '2 hours ago',
    content:
        'Just reached 10k followers for our new client! Growth hacking works.',
    likes: 134,
    comments: 21,
  ),
  ZinkoPost(
    id: 'post10',
    userName: 'Liam Carter',
    userRole: 'AI Researcher',
    userAvatar: 'https://i.pravatar.cc/300?u=11',
    timeAgo: '4 hours ago',
    content:
        'The new LLM from OpenAI is impressively fast. Benchmark tests incoming.',
    likes: 45,
    comments: 12,
  ),
  ZinkoPost(
    id: 'post11',
    userName: 'Mia Thompson',
    userRole: 'DevOps',
    userAvatar: 'https://i.pravatar.cc/300?u=12',
    timeAgo: '6 hours ago',
    content:
        'Finally migrating everything to Kubernetes. Anyone have tips for stateful sets?',
    likes: 22,
    comments: 18,
  ),
  ZinkoPost(
    id: 'post12',
    userName: 'Ryan Davies',
    userRole: 'Security',
    userAvatar: 'https://i.pravatar.cc/300?u=13',
    timeAgo: 'Yesterday',
    content:
        'Update your dependencies folks! There is a new RCE vuln out there.',
    likes: 210,
    comments: 32,
  ),
  ZinkoPost(
    id: 'post13',
    userName: 'Grace Bell',
    userRole: 'Motion Designer',
    userAvatar: 'https://i.pravatar.cc/300?u=14',
    timeAgo: '2 days ago',
    content:
        'Just finished a cool Lottie animation for a health tech app. Check it out!',
    likes: 95,
    comments: 6,
  ),
  ZinkoPost(
    id: 'post14',
    userName: 'William Scott',
    userRole: 'Founder',
    userAvatar: 'https://i.pravatar.cc/300?u=15',
    timeAgo: '3 days ago',
    content: 'Hiring a Senior Flutter Developer. Remote or London. DM me!',
    likes: 156,
    comments: 45,
  ),
  ZinkoPost(
    id: 'post15',
    userName: 'Leo Maxwell',
    userRole: 'Mobile Dev',
    userAvatar: 'https://i.pravatar.cc/300?u=7',
    timeAgo: '4 days ago',
    content: 'The coffee at Bohemian Brew is still the best fuel for coding.',
    likes: 45,
    comments: 3,
  ),
  ZinkoPost(
    id: 'post16',
    userName: 'Isabella Martinez',
    userRole: 'Content Creator',
    userAvatar: 'https://i.pravatar.cc/300?u=16',
    timeAgo: '3 hours ago',
    content:
        'Just launched a new campaign for a sustainable fashion brand. Excited to see the impact!',
    postImage:
        'https://images.unsplash.com/photo-1558769132-cb1aea3c8565?auto=format&fit=crop&w=800&q=80',
    likes: 78,
    comments: 12,
  ),
  ZinkoPost(
    id: 'post17',
    userName: 'Marcus Johnson',
    userRole: 'Blockchain Developer',
    userAvatar: 'https://i.pravatar.cc/300?u=17',
    timeAgo: '6 hours ago',
    content:
        'Smart contract deployment successful! The future is decentralized.',
    likes: 92,
    comments: 15,
  ),
  ZinkoPost(
    id: 'post18',
    userName: 'Amelia Brown',
    userRole: 'HR Consultant',
    userAvatar: 'https://i.pravatar.cc/300?u=18',
    timeAgo: '1 day ago',
    content:
        'Hiring tip: Culture fit is just as important as skills. Build teams that thrive together.',
    likes: 156,
    comments: 28,
  ),
  ZinkoPost(
    id: 'post19',
    userName: 'Daniel Kim',
    userRole: 'Game Developer',
    userAvatar: 'https://i.pravatar.cc/300?u=19',
    timeAgo: '2 days ago',
    content:
        'Working on a new indie game. Can\'t wait to share the trailer next month!',
    postImage:
        'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?auto=format&fit=crop&w=800&q=80',
    likes: 234,
    comments: 42,
  ),
  ZinkoPost(
    id: 'post20',
    userName: 'Sophia Anderson',
    userRole: 'Legal Tech Advisor',
    userAvatar: 'https://i.pravatar.cc/300?u=20',
    timeAgo: '5 hours ago',
    content:
        'New GDPR updates are rolling out. Make sure your startup is compliant!',
    likes: 67,
    comments: 19,
  ),
];

final List<ZinkoChat> kAllChats = [
  ZinkoChat(
    id: 'c1',
    name: 'Sophie Turner',
    lastMessage: 'Hey, are you at Urban Hive today?',
    time: '10:05 AM',
    avatar: 'https://i.pravatar.cc/150?u=2',
    unreadCount: 2,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c2',
    name: 'Michael Chen',
    lastMessage: 'Check out the new repo I sent you.',
    time: 'Yesterday',
    avatar: 'https://i.pravatar.cc/300?u=1',
    unreadCount: 0,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c3',
    name: 'Emma Rodriguez',
    lastMessage: 'The sketches are ready!',
    time: '2 days ago',
    avatar: 'https://i.pravatar.cc/300?u=4',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c4',
    name: 'James Watson',
    lastMessage: 'Meeting moved to 3pm.',
    time: 'Mon',
    avatar: 'https://i.pravatar.cc/300?u=3',
    unreadCount: 1,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c5',
    name: 'Sarah Jenkins',
    lastMessage: 'Can you help with the SQL query?',
    time: 'Tue',
    avatar: 'https://i.pravatar.cc/300?u=6',
    unreadCount: 4,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c6',
    name: 'Leo Maxwell',
    lastMessage: 'Let\'s grab coffee later.',
    time: 'Wed',
    avatar: 'https://i.pravatar.cc/300?u=7',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c7',
    name: 'Olivia Reed',
    lastMessage: 'User tests look good.',
    time: 'Thu',
    avatar: 'https://i.pravatar.cc/300?u=8',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c8',
    name: 'Noah Bennett',
    lastMessage: 'API is deployed.',
    time: 'Fri',
    avatar: 'https://i.pravatar.cc/300?u=9',
    unreadCount: 0,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c9',
    name: 'Chloe Foster',
    lastMessage: 'Ad campaign started.',
    time: 'Sat',
    avatar: 'https://i.pravatar.cc/300?u=10',
    unreadCount: 2,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c10',
    name: 'Liam Carter',
    lastMessage: 'Found a new ML paper.',
    time: 'Sun',
    avatar: 'https://i.pravatar.cc/300?u=11',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c11',
    name: 'Mia Thompson',
    lastMessage: 'Docker build failed again.',
    time: '2h ago',
    avatar: 'https://i.pravatar.cc/300?u=12',
    unreadCount: 0,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c12',
    name: 'Ryan Davies',
    lastMessage: 'Check the firewall logs.',
    time: '5h ago',
    avatar: 'https://i.pravatar.cc/300?u=13',
    unreadCount: 1,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c13',
    name: 'Grace Bell',
    lastMessage: 'Sent the final MP4.',
    time: 'Yesterday',
    avatar: 'https://i.pravatar.cc/300?u=14',
    unreadCount: 0,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c14',
    name: 'William Scott',
    lastMessage: 'Great work on the pitch!',
    time: 'Mon',
    avatar: 'https://i.pravatar.cc/300?u=15',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c15',
    name: 'Leo Maxwell',
    lastMessage: 'Ready for the meetup?',
    time: 'Tue',
    avatar: 'https://i.pravatar.cc/300?u=7',
    unreadCount: 3,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c16',
    name: 'Isabella Martinez',
    lastMessage: 'Check out my latest blog post!',
    time: '1h ago',
    avatar: 'https://i.pravatar.cc/300?u=16',
    unreadCount: 1,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c17',
    name: 'Marcus Johnson',
    lastMessage: 'Smart contract is live!',
    time: '3h ago',
    avatar: 'https://i.pravatar.cc/300?u=17',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c18',
    name: 'Amelia Brown',
    lastMessage: 'Interview scheduled for tomorrow.',
    time: 'Yesterday',
    avatar: 'https://i.pravatar.cc/300?u=18',
    unreadCount: 2,
    isOnline: false,
  ),
  ZinkoChat(
    id: 'c19',
    name: 'Daniel Kim',
    lastMessage: 'Game demo is ready!',
    time: 'Mon',
    avatar: 'https://i.pravatar.cc/300?u=19',
    unreadCount: 0,
    isOnline: true,
  ),
  ZinkoChat(
    id: 'c20',
    name: 'Sophia Anderson',
    lastMessage: 'Legal docs reviewed.',
    time: 'Sun',
    avatar: 'https://i.pravatar.cc/300?u=20',
    unreadCount: 0,
    isOnline: false,
  ),
];

final List<ZinkoGroup> kAllGroups = [
  ZinkoGroup(
      id: 'g1',
      name: 'London Developers',
      memberCount: '1200 Members',
      image: 'https://picsum.photos/seed/dev/200'),
  ZinkoGroup(
      id: 'g2',
      name: 'Startup Founders',
      memberCount: '800 Members',
      image: 'https://picsum.photos/seed/startup/200'),
  ZinkoGroup(
      id: 'g3',
      name: 'UI/UX Designers',
      memberCount: '1500 Members',
      image: 'https://picsum.photos/seed/design/200'),
  ZinkoGroup(
      id: 'g4',
      name: 'Cybersecurity Hub',
      memberCount: '500 Members',
      image: 'https://picsum.photos/seed/sec/200'),
  ZinkoGroup(
      id: 'g5',
      name: 'Digital Nomads London',
      memberCount: '2000 Members',
      image: 'https://picsum.photos/seed/nomad/200'),
  ZinkoGroup(
      id: 'g6',
      name: 'Product Managers',
      memberCount: '450 Members',
      image: 'https://picsum.photos/seed/pm/200'),
  ZinkoGroup(
      id: 'g7',
      name: 'Web3 Architects',
      memberCount: '300 Members',
      image: 'https://picsum.photos/seed/web3/200'),
  ZinkoGroup(
      id: 'g8',
      name: 'Mobile App Builders',
      memberCount: '1100 Members',
      image: 'https://picsum.photos/seed/app/200'),
  ZinkoGroup(
      id: 'g9',
      name: 'AI Researchers',
      memberCount: '600 Members',
      image: 'https://picsum.photos/seed/ai/200'),
  ZinkoGroup(
      id: 'g10',
      name: 'Zinko Community',
      memberCount: '5000 Members',
      image: 'https://picsum.photos/seed/zinko/200'),
  ZinkoGroup(
      id: 'g11',
      name: 'London Foodies',
      memberCount: '900 Members',
      image: 'https://picsum.photos/seed/food/200'),
  ZinkoGroup(
      id: 'g12',
      name: 'Remote Work Tips',
      memberCount: '3200 Members',
      image: 'https://picsum.photos/seed/work/200'),
  ZinkoGroup(
      id: 'g13',
      name: 'Creative Writers',
      memberCount: '250 Members',
      image: 'https://picsum.photos/seed/write/200'),
  ZinkoGroup(
      id: 'g14',
      name: 'iOS Apprentices',
      memberCount: '150 Members',
      image: 'https://picsum.photos/seed/ios/200'),
  ZinkoGroup(
      id: 'g15',
      name: 'Tech Investors',
      memberCount: '400 Members',
      image: 'https://picsum.photos/seed/money/200'),
  ZinkoGroup(
      id: 'g16',
      name: 'Blockchain Enthusiasts',
      memberCount: '750 Members',
      image: 'https://picsum.photos/seed/blockchain/200'),
  ZinkoGroup(
      id: 'g17',
      name: 'Content Creators Hub',
      memberCount: '1800 Members',
      image: 'https://picsum.photos/seed/content/200'),
  ZinkoGroup(
      id: 'g18',
      name: 'Legal Tech Network',
      memberCount: '320 Members',
      image: 'https://picsum.photos/seed/legal/200'),
  ZinkoGroup(
      id: 'g19',
      name: 'Game Developers Guild',
      memberCount: '890 Members',
      image: 'https://picsum.photos/seed/gaming/200'),
  ZinkoGroup(
      id: 'g20',
      name: 'Sustainable Tech',
      memberCount: '650 Members',
      image: 'https://picsum.photos/seed/green/200'),
];

final List<ZinkoConnection> kAllConnections = [
  ZinkoConnection(
      id: 'u1',
      name: 'Michael Chen',
      role: 'Full Stack Dev',
      avatar: 'https://i.pravatar.cc/150?u=1'),
  ZinkoConnection(
      id: 'u2',
      name: 'Sophie Turner',
      role: 'UI/UX Designer',
      avatar: 'https://i.pravatar.cc/150?u=2'),
  ZinkoConnection(
      id: 'u6',
      name: 'Sarah Jenkins',
      role: 'Data Scientist',
      avatar: 'https://i.pravatar.cc/150?u=6'),
  ZinkoConnection(
      id: 'u8',
      name: 'Olivia Reed',
      role: 'UX Researcher',
      avatar: 'https://i.pravatar.cc/150?u=8'),
  ZinkoConnection(
      id: 'u11',
      name: 'Liam Carter',
      role: 'AI Researcher',
      avatar: 'https://i.pravatar.cc/150?u=11'),
  ZinkoConnection(
      id: 'u15',
      name: 'William Scott',
      role: 'Entrepreneur',
      avatar: 'https://i.pravatar.cc/150?u=15'),
  ZinkoConnection(
      id: 'u3',
      name: 'James Watson',
      role: 'Product Manager',
      avatar: 'https://i.pravatar.cc/150?u=3'),
  ZinkoConnection(
      id: 'u4',
      name: 'Emma Rodriguez',
      role: 'Graphic Designer',
      avatar: 'https://i.pravatar.cc/150?u=4'),
  ZinkoConnection(
      id: 'u5',
      name: 'David Wilson',
      role: 'iOS Developer',
      avatar: 'https://i.pravatar.cc/150?u=5'),
  ZinkoConnection(
      id: 'u7',
      name: 'Leo Maxwell',
      role: 'Mobile Dev',
      avatar: 'https://i.pravatar.cc/150?u=7'),
  ZinkoConnection(
      id: 'u9',
      name: 'Noah Bennett',
      role: 'Backend Architect',
      avatar: 'https://i.pravatar.cc/150?u=9'),
  ZinkoConnection(
      id: 'u10',
      name: 'Chloe Foster',
      role: 'Marketer',
      avatar: 'https://i.pravatar.cc/150?u=10'),
  ZinkoConnection(
      id: 'u12',
      name: 'Mia Thompson',
      role: 'DevOps Engineer',
      avatar: 'https://i.pravatar.cc/150?u=12'),
  ZinkoConnection(
      id: 'u13',
      name: 'Ryan Davies',
      role: 'Security',
      avatar: 'https://i.pravatar.cc/150?u=13'),
  ZinkoConnection(
      id: 'u14',
      name: 'Grace Bell',
      role: 'Motion Designer',
      avatar: 'https://i.pravatar.cc/150?u=14'),
  ZinkoConnection(
      id: 'u16',
      name: 'Isabella Martinez',
      role: 'Content Creator',
      avatar: 'https://i.pravatar.cc/150?u=16'),
  ZinkoConnection(
      id: 'u17',
      name: 'Marcus Johnson',
      role: 'Blockchain Developer',
      avatar: 'https://i.pravatar.cc/150?u=17'),
  ZinkoConnection(
      id: 'u18',
      name: 'Amelia Brown',
      role: 'HR Consultant',
      avatar: 'https://i.pravatar.cc/150?u=18'),
  ZinkoConnection(
      id: 'u19',
      name: 'Daniel Kim',
      role: 'Game Developer',
      avatar: 'https://i.pravatar.cc/150?u=19'),
  ZinkoConnection(
      id: 'u20',
      name: 'Sophia Anderson',
      role: 'Legal Tech Advisor',
      avatar: 'https://i.pravatar.cc/150?u=20'),
];

// ─────────────────────────────────────────────────────────────
//  SAMPLE DATA — BOOKINGS
// ─────────────────────────────────────────────────────────────

final List<ZinkoBooking> kAllBookings = [
  ZinkoBooking(
    id: 'b1',
    placeId: 'p4',
    placeName: 'Urban Hive',
    location: 'Shoreditch, London',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 2)),
    timeSlot: '09:00 AM – 01:00 PM',
    tableNumber: 'T4',
    subtotal: 35.0,
    tax: 3.5,
    total: 38.5,
    isCompleted: true,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b2',
    placeId: 'p1',
    placeName: 'Cafe Work',
    location: 'Canary Wharf, London',
    imageUrl:
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 1)),
    timeSlot: '01:00 PM – 05:00 PM',
    tableNumber: 'T2',
    subtotal: 20.0,
    tax: 2.0,
    total: 22.0,
    isCompleted: false,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b3',
    placeId: 'p3',
    placeName: 'The Reading Room',
    location: 'Bloomsbury, London',
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 5)),
    timeSlot: '10:00 AM – 02:00 PM',
    tableNumber: 'T1',
    subtotal: 25.0,
    tax: 2.5,
    total: 27.5,
    isCompleted: true,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b4',
    placeId: 'p12',
    placeName: 'The Glass House',
    location: 'London Bridge, London',
    imageUrl:
        'https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 2)),
    timeSlot: '09:00 AM – 06:00 PM',
    tableNumber: 'Desk 5',
    subtotal: 55.0,
    tax: 5.5,
    total: 60.5,
    isCompleted: false,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b5',
    placeId: 'p7',
    placeName: 'The Nook',
    location: 'Islington, London',
    imageUrl:
        'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 10)),
    timeSlot: '02:00 PM – 05:00 PM',
    tableNumber: 'T8',
    subtotal: 12.0,
    tax: 1.2,
    total: 13.2,
    isCompleted: true,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b6',
    placeId: 'p10',
    placeName: 'Tech Hub London',
    location: 'Old Street, London',
    imageUrl:
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 1)),
    timeSlot: '09:00 AM – 06:00 PM',
    tableNumber: 'Desk 12',
    subtotal: 40.0,
    tax: 4.0,
    total: 44.0,
    isCompleted: true,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b7',
    placeId: 'p2',
    placeName: 'Bohemian Brew',
    location: 'Notting Hill, London',
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 3)),
    timeSlot: '02:00 PM – 04:00 PM',
    tableNumber: 'T5',
    subtotal: 12.0,
    tax: 1.2,
    total: 13.2,
    isCompleted: false,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b8',
    placeId: 'p15',
    placeName: 'Neon Work',
    location: 'Soho, London',
    imageUrl:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 5)),
    timeSlot: '06:00 PM – 10:00 PM',
    tableNumber: 'Desk 2',
    subtotal: 30.0,
    tax: 3.0,
    total: 33.0,
    isCompleted: false,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b9',
    placeId: 'p5',
    placeName: 'The Mill',
    location: 'Soho, London',
    imageUrl:
        'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 15)),
    timeSlot: '09:00 AM – 05:00 PM',
    tableNumber: 'Studio A',
    subtotal: 65.0,
    tax: 6.5,
    total: 71.5,
    isCompleted: true,
    placeType: PlaceType.coworking,
  ),
  // ZinkoBooking(
  //   id: 'b10',
  //   placeId: 'p11',
  //   placeName: 'Zen Garden Cafe',
  //   location: 'Kensington, London',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1445116572660-23a0a880155b?auto=format&fit=crop&w=800&q=80',
  //   date: DateTime.now().subtract(const Duration(days: 20)),
  //   timeSlot: '11:00 AM – 03:00 PM',
  //   tableNumber: 'T3',
  //   subtotal: 24.0,
  //   tax: 2.4,
  //   total: 26.4,
  //   isCompleted: true,
  //   placeType: PlaceType.cafe,
  // ),
  // ZinkoBooking(
  //   id: 'b11',
  //   placeId: 'p13',
  //   placeName: 'Sky Garden Cafe',
  //   location: 'Fenchurch St, London',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1549416845-816790b4bf54?auto=format&fit=crop&w=800&q=80',
  //   date: DateTime.now().add(const Duration(days: 7)),
  //   timeSlot: '09:00 AM – 11:00 AM',
  //   tableNumber: 'Window 2',
  //   subtotal: 16.0,
  //   tax: 1.6,
  //   total: 17.6,
  //   isCompleted: false,
  //   placeType: PlaceType.cafe,
  // ),
  ZinkoBooking(
    id: 'b12',
    placeId: 'p9',
    placeName: 'The Loft Studio',
    location: 'Hackney, London',
    imageUrl:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 30)),
    timeSlot: '10:00 AM – 06:00 PM',
    tableNumber: 'Desk 1',
    subtotal: 64.0,
    tax: 6.4,
    total: 70.4,
    isCompleted: true,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b13',
    placeId: 'p8',
    placeName: 'WorkHub Central',
    location: 'Westminster, London',
    imageUrl:
        'https://images.unsplash.com/photo-1497366412874-3415097a27e7?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 40)),
    timeSlot: '09:00 AM – 05:00 PM',
    tableNumber: 'Office 4',
    subtotal: 45.0,
    tax: 4.5,
    total: 49.5,
    isCompleted: true,
    placeType: PlaceType.office,
  ),
  ZinkoBooking(
    id: 'b14',
    placeId: 'p4',
    placeName: 'Urban Hive',
    location: 'Shoreditch, London',
    imageUrl:
        'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 10)),
    timeSlot: '01:00 PM – 05:00 PM',
    tableNumber: 'Table 14',
    subtotal: 35.0,
    tax: 3.5,
    total: 38.5,
    isCompleted: false,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b15',
    placeId: 'p6',
    placeName: 'Code & Brew',
    location: 'Hackney, London',
    imageUrl:
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 2)),
    timeSlot: '07:00 PM – 10:00 PM',
    tableNumber: 'Booth 1',
    subtotal: 21.0,
    tax: 2.1,
    total: 23.1,
    isCompleted: true,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b16',
    placeId: 'p16',
    placeName: 'Riverside Cafe',
    location: 'Southbank, London',
    imageUrl:
        'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 4)),
    timeSlot: '10:00 AM – 02:00 PM',
    tableNumber: 'Riverside 3',
    subtotal: 24.0,
    tax: 2.4,
    total: 26.4,
    isCompleted: false,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b17',
    placeId: 'p17',
    placeName: 'Innovation Lab',
    location: 'King\'s Cross, London',
    imageUrl:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 6)),
    timeSlot: '09:00 AM – 05:00 PM',
    tableNumber: 'Lab Station 7',
    subtotal: 50.0,
    tax: 5.0,
    total: 55.0,
    isCompleted: false,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b18',
    placeId: 'p18',
    placeName: 'The Green Room',
    location: 'Hampstead, London',
    imageUrl:
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 7)),
    timeSlot: '11:00 AM – 03:00 PM',
    tableNumber: 'Garden 2',
    subtotal: 28.0,
    tax: 2.8,
    total: 30.8,
    isCompleted: true,
    placeType: PlaceType.cafe,
  ),
  ZinkoBooking(
    id: 'b19',
    placeId: 'p19',
    placeName: 'Digital Nomad Hub',
    location: 'Covent Garden, London',
    imageUrl:
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().add(const Duration(days: 8)),
    timeSlot: '09:00 AM – 06:00 PM',
    tableNumber: 'Hot Desk 15',
    subtotal: 40.0,
    tax: 4.0,
    total: 44.0,
    isCompleted: false,
    placeType: PlaceType.coworking,
  ),
  ZinkoBooking(
    id: 'b20',
    placeId: 'p20',
    placeName: 'Artisan Coffee House',
    location: 'Brixton, London',
    imageUrl:
        'https://images.unsplash.com/photo-1453614512568-c4024d13c247?auto=format&fit=crop&w=800&q=80',
    date: DateTime.now().subtract(const Duration(days: 12)),
    timeSlot: '02:00 PM – 06:00 PM',
    tableNumber: 'Corner 4',
    subtotal: 20.0,
    tax: 2.0,
    total: 22.0,
    isCompleted: true,
    placeType: PlaceType.cafe,
  ),
];

// ─────────────────────────────────────────────────────────────
//  BACKWARD-COMPAT ALIASES
// ─────────────────────────────────────────────────────────────

typedef WorkspaceModel = ZinkoPlace;
typedef BookingModel = ZinkoBooking;
typedef EventModel = ZinkoEvent;
typedef PostModel = ZinkoPost;
typedef ChatModel = ZinkoChat;
typedef GroupModel = ZinkoGroup;
typedef ConnectionModel = ZinkoConnection;
typedef MapPersonModel = ZinkoPerson;

List<ZinkoPlace> get kSampleWorkspaces => kAllPlaces;
List<ZinkoEvent> get kSampleEvents => kAllEvents;
List<ZinkoPost> get kSamplePosts => kAllPosts;
List<ZinkoChat> get kSampleChats => kAllChats;
List<ZinkoGroup> get kSampleGroups => kAllGroups;
List<ZinkoConnection> get kSampleConnections => kAllConnections;
List<ZinkoPerson> get kSampleMapPeople => kAllPeople;
