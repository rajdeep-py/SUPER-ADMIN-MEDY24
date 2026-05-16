class Customer {
  final String? customerId;
  final String? phoneNumber;
  final String? fullName;
  final String? email;
  final String? alternativePhoneNo;
  final String? status;
  final String? profilePhoto;
  final List<SavedAddress>? savedAddresses;

  Customer({
    this.customerId,
    this.phoneNumber,
    this.fullName,
    this.email,
    this.alternativePhoneNo,
    this.status,
    this.profilePhoto,
    this.savedAddresses,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      phoneNumber: json['phone_number'],
      fullName: json['full_name'],
      email: json['email'],
      alternativePhoneNo: json['alternative_phone_no'],
      status: json['status'],
      profilePhoto: json['profile_photo'],
      savedAddresses: (json['saved_addresses'] as List?)
          ?.map((e) => SavedAddress.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'email': email,
      'alternative_phone_no': alternativePhoneNo,
      'status': status,
      'profile_photo': profilePhoto,
      'saved_addresses': savedAddresses?.map((e) => e.toJson()).toList(),
    };
  }
}

class SavedAddress {
  final int? id;
  final String? address1;
  final double? latitude;
  final double? longitude;
  final String? streetAddress;
  final String? createdAt;

  SavedAddress({
    this.id,
    this.address1,
    this.latitude,
    this.longitude,
    this.streetAddress,
    this.createdAt,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['id'],
      address1: json['address_1'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      streetAddress: json['street_address'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_1': address1,
      'latitude': latitude,
      'longitude': longitude,
      'street_address': streetAddress,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return streetAddress ?? address1 ?? '';
  }
}
