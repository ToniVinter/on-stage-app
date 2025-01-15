import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/create_or_edit_group_request.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'group_template_repository.g.dart';

@RestApi()
abstract class GroupTemplateRepository {
  factory GroupTemplateRepository(Dio dio) = _GroupTemplateRepository;

  @GET(API.groupsTemplate)
  Future<List<GroupTemplateModel>> getGroupsTemplate();

  @GET(API.groupTemplate)
  Future<GroupTemplateModel> getGroupTemplate(@Path('id') String id);

  @POST(API.createGroup)
  Future<GroupTemplateModel> createGroup(
    @Body() CreateOrEditGroupRequest group,
  );

  @PUT(API.updateGroup)
  Future<GroupTemplateModel> updateGroup(
    @Path('id') String id,
    @Body() CreateOrEditGroupRequest group,
  );

  @DELETE(API.deleteGroup)
  Future<void> deleteGroup(@Path('id') String id);
}
