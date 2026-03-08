import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/hive_constants.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveConstants.userTypeId)
class UserModel extends UserEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String fullName;

  @override
  @HiveField(2)
  final String email;

  @HiveField(3)
  final String passwordHash;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.passwordHash,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
        );

  factory UserModel.fromEntity(UserEntity entity, String passwordHash) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      passwordHash: passwordHash,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? passwordHash,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }
}
