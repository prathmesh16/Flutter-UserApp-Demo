import 'package:flutter_userapp_demo/features/user_list/data/cache/user_cache.dart';
import 'package:flutter_userapp_demo/features/user_list/data/network/user_api_service.dart';
import 'package:flutter_userapp_demo/features/user_list/data/models/user.dart';
import 'package:flutter_userapp_demo/features/user_list/data/models/paging_helper.dart';

class UserRepository {
  final UserApiService userApiService = new UserApiService();
  UserCache userCache = new UserCache();

  Future<String> addUserRequest(User user) async {
    return await userApiService.addUserRequest(user);
  }

  Future<List<User>> fetchPaginatedUserList(filters, PagingHelper _pagingHelper,
      _refreshPage, bool clearCache) async {
    if (clearCache) {
      userCache.clearUserCache();
    } else if (userCache.isUserListPresent(_pagingHelper.pageNo)) {
      return userCache.getFromCache(_pagingHelper.pageNo);
    }
    List<User> userList = await userApiService.fetchPaginatedUserList(
        filters, _pagingHelper, _refreshPage);
    userCache.addToUserCache(userList, _pagingHelper.pageNo);
    return userList;
  }

  Future<List<User>> fetchUserList(filters, pageNo) async {
    return await userApiService.fetchUserList(filters, pageNo);
  }

  Future<void> updateUserRequest(User user, var callback) async {
    await userApiService.updateUserRequest(user, callback);
  }

  Future<String> deleteUserRequest(int id) async {
    return await userApiService.deleteUserRequest(id);
  }
}
