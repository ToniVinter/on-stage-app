import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/features/login/domain/user_request.dart';
import 'package:on_stage_app/app/features/user/domain/models/profile/user_profile.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio) = _UserRepository;

  @GET(API.users)
  Future<List<UserModel>> getUsers();

  @GET(API.user)
  Future<UserModel> getUserById(
    @Path('id') String id,
  );

  @GET(API.userProfileInfo)
  Future<UserProfileInfo> getUserProfileInfo(
    @Path('id') String id,
  );

  @GET(API.userPhoto)
  Future<String> getUserPhotoUrl();

  @GET(API.photoByUserId)
  Future<String> getPhotoByUserId(@Path('userId') String userId);

  @GET(API.currentUser)
  Future<UserModel> getCurrentUser();

  @PUT(API.users)
  Future<UserModel> editUser(
    @Body() UserRequest updatedUser,
  );

  @GET(API.checkPermission)
  Future<bool> checkPermission(
    @Query('permission') String permission,
  );

  @DELETE(API.user)
  Future<void> deleteUser(
    @Path('id') String id,
  );
}
