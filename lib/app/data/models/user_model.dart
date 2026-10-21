import 'package:flutter/widgets.dart';


class UserModel {
  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.role = 'CUSTOMER',
    this.status = 'ACTIVE',
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String role;
  final String status;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.take(1).toString().toUpperCase();
    return (parts.first.characters.take(1).toString() + parts[1].characters.take(1).toString()).toUpperCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'ຜູ້ໃຊ້',
        email: json['email']?.toString(),
        phone: json['phone']?.toString(),
        avatar: json['avatar']?.toString(),
        role: json['role']?.toString() ?? 'CUSTOMER',
        status: json['status']?.toString() ?? 'ACTIVE',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'role': role,
        'status': status,
      };

  UserModel copyWith({String? name, String? email, String? avatar}) => UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone,
        avatar: avatar ?? this.avatar,
        role: role,
        status: status,
      );
}

class AuthResult {
  AuthResult({required this.accessToken, required this.refreshToken, required this.user});

  final String accessToken;
  final String refreshToken;
  final UserModel user;

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        accessToken: json['accessToken']?.toString() ?? '',
        refreshToken: json['refreshToken']?.toString() ?? '',
        user: UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map? ?? {})),
      );
}

class AddressModel {
  AddressModel({
    required this.id,
    required this.recipient,
    required this.phone,
    required this.province,
    required this.district,
    this.village,
    required this.detail,
    this.label = 'ເຮືອນ',
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String recipient;
  final String phone;
  final String province;
  final String district;
  final String? village;
  final String detail;
  final bool isDefault;

  String get fullAddress => [detail, village, district, province].where((e) => (e ?? '').isNotEmpty).join(', ');

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id']?.toString() ?? '',
        label: json['label']?.toString() ?? 'ເຮືອນ',
        recipient: json['recipient']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        province: json['province']?.toString() ?? '',
        district: json['district']?.toString() ?? '',
        village: json['village']?.toString(),
        detail: json['detail']?.toString() ?? '',
        isDefault: json['isDefault'] == true,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'recipient': recipient,
        'phone': phone,
        'province': province,
        'district': district,
        'village': village,
        'detail': detail,
        'isDefault': isDefault,
      };
}
