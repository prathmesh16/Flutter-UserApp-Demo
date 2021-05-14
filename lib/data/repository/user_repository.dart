import 'package:flutter_userapp_demo/data/network/user_api_service.dart';
import 'package:flutter_userapp_demo/features/common/models/user.dart';

class UserRepository{
  final UserApiService userApiService = new UserApiService();

  Future<String> addUserRequest(User user) async{
    return await userApiService.addUserRequest(user);
  }

  Future<List<User>> fetchPaginatedUserList(filters, _pagingHelper,_refreshPage)async {
    return await userApiService.fetchPaginatedUserList(filters, _pagingHelper,_refreshPage);
  }

  Future<List<User>> fetchUserList(filters, pageNo)async{
    return await userApiService.fetchUserList(filters,pageNo);
  }

  Future<void> updateUserRequest(User user,var callback) async {
    await userApiService.updateUserRequest(user,callback);
  }

  Future<String> deleteUserRequest(int id)async{
    return await userApiService.deleteUserRequest(id);
  }
}