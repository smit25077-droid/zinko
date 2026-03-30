import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile implements UseCase<UserEntity, UpdateUserParams> {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      email: params.email,
      phone: params.phone,
      role: params.role,
      bio: params.bio,
      profileImage: params.profileImage,
      membership: params.membership,
      isEmailVerified: params.isEmailVerified,
      isPhoneVerified: params.isPhoneVerified,
    );
  }
}

class UpdateUserParams {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String bio;
  final String? profileImage;
  final String? membership;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;

  UpdateUserParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.bio,
    this.profileImage,
    this.membership,
    this.isEmailVerified,
    this.isPhoneVerified,
  });
}
