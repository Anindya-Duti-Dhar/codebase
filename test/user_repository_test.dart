import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:codebase/data/repository/user_repository.dart';
import 'package:codebase/core/api.dart';
import 'package:codebase/core/app_utils.dart';

class MockAPI extends Mock implements API {}
class MockAppUtils extends Mock implements AppUtils {}

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockAPI mockAPI;
    late MockAppUtils mockAppUtils;

    setUp(() {
      mockAPI = MockAPI();
      mockAppUtils = MockAppUtils();
      userRepository = UserRepository(api: mockAPI, appUtils: mockAppUtils);
    });

    test('should return user list successfully', () async {
      final fakeApiResponse = '''
      {
        "Success": true,
        "Message": "Fetched",
        "Packet": {
          "page": 1,
          "per_page": 6,
          "total": 12,
          "total_pages": 2,
          "data": [
            {
              "id": 1,
              "email": "george.bluth@reqres.in",
              "first_name": "George",
              "last_name": "Bluth",
              "avatar": "https://reqres.in/img/faces/1-image.jpg"
            }
          ]
        }
      }
      ''';

      when(mockAppUtils.checkInternet()).thenAnswer((_) async => 'wifi');
      when(mockAPI.fetch(httpAddress: anyNamed("httpAddress") ?? "httpAddress"))
          .thenAnswer((_) async => fakeApiResponse);

      await userRepository.userListFetch(
        pageNo: 1,
        onComplete: (isSuccess, message, data) {
          expect(isSuccess, true);
          expect(message, isNotNull);
          expect(data.data?.isNotEmpty, true);
          expect(data.data![0].firstName, "George");
        },
      );
    });
  });
}
