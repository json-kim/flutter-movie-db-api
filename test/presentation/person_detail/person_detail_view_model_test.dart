import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/data/repository/api_cast_data_repository.dart';
import 'package:movie_search/data/repository/api_person_data_repository.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/get_person_detail_use_case.dart';
import 'package:movie_search/domain/usecase/use_case.dart';
import 'package:movie_search/presentation/person_detail/person_detail_event.dart';
import 'package:movie_search/presentation/person_detail/person_detail_view_model.dart';

void main() {
  test('인물 가져오기 뷰모델을 테스트합니다.', () async {
    final fakeCastUseCase = FakeCastUseCase();
    final fakePersonUseCase = FakePersonUseCase();

    final PersonDetailViewModel fakeViewModel =
        PersonDetailViewModel(287, fakePersonUseCase, fakeCastUseCase);

    await fakeViewModel.onEvent(const PersonDetailEvent.loadPerson(287));

    final TMDBApi api = TMDBApi();

    final PersonDetailViewModel realViewModel = PersonDetailViewModel(
        287,
        GetPersonDetailUseCase(ApiPersonDataRepository(api)),
        GetCastWithPersonUseCase(ApiCastDataRepository(api)));

    await realViewModel.onEvent(PersonDetailEvent.loadPerson(287));

    expect(fakeViewModel.state.person, realViewModel.state.person);

    expect(fakeViewModel.state.casts.first, fakeViewModel.state.casts.first);
  });
}

class FakePersonUseCase implements UseCase<Person, int> {
  @override
  Future<Result<Person>> call(int params) async {
    return Result.success(fakePerson);
  }
}

class FakeCastUseCase implements UseCase<List<Cast>, int> {
  @override
  Future<Result<List<Cast>>> call(int params) async {
    return Result.success(fakeCasts);
  }
}

final Person fakePerson = Person.fromJson(jsonDecode(fakePersonJson));

final List<Cast> fakeCasts =
    (jsonDecode(fakeCastJson) as List).map((e) => Cast.fromJson(e)).toList();

const fakePersonJson = '''
{
    "adult": false,
    "also_known_as": [
        "برد پیت",
        "Бред Пітт",
        "Брэд Питт",
        "畢·彼特",
        "ブラッド・ピット",
        "브래드 피트",
        "براد بيت",
        "แบรด พิตต์",
        "William Bradley \"Brad\" Pitt",
        "William Bradley Pitt",
        "Μπραντ Πιτ",
        "布拉德·皮特",
        "Breds Pits",
        "ബ്രാഡ് പിറ്റ് "
    ],
    "biography": "",
    "birthday": "1963-12-18",
    "deathday": null,
    "gender": 2,
    "homepage": null,
    "id": 287,
    "imdb_id": "nm0000093",
    "known_for_department": "Acting",
    "name": "Brad Pitt",
    "place_of_birth": "Shawnee, Oklahoma, USA",
    "popularity": 21.444,
    "profile_path": "/hfkzP7YstXRsj2IM1a8lLz8bvst.jpg"
}
''';

const fakeCastJson = '''
[
        {
            "adult": false,
            "backdrop_path": "/o67MmFburfckl6iPa4DVkranLi3.jpg",
            "genre_ids": [
                14,
                18,
                10749
            ],
            "id": 297,
            "original_language": "en",
            "original_title": "Meet Joe Black",
            "overview": "윌리암 패리쉬는 65세 생일을 앞둔 어느날, '예(YES)'라는 꿈결같은 울림소리에 잠을 깬다. 그는 사업에 성공을 거두었고 화려한 저택에서 두 딸과 안정된 가정생활을 누리고 있었다. 큰딸이 아버지 빌의 성대한 생일파티를 준비하는 동안 빌은 그의 오른팔이자 둘째딸 수잔의 남자 친구인 드류를 시켜 네트워크 회사 합병을 고려하고 있었다. 레지던트인 수잔은 커피숍에서 낯선 남자를 만나게 되는데 그들은 첫눈에 서로에게 호감을 느끼게 되고 많은 대화를 나눈다. 그들은 아쉬움을 남기며 이름조차 묻지 않은 채 헤어진다. 망설이며 걸음을 재촉하지 못하던 남자는 횡단보도에서 교통사고를 당해 죽음을 맞는다.  한편, 빌에게 잠자리에서 들었던 목소리의 주인공이 수잔이 커피숍에서 만났던 남자의 몸을 빌어 나타났다. 그는 자신이 저승사자이고 빌을 데려가기 위해 나타났다고 했다. 그러나 그 저승사자는 이 남자의 몸을 빌려 당분간 빌의 집에서 생활하기를 원했고 조 블랙이라는 이름으로 빌의 집에서 인간으로 환생하여 생활한다. 아버지의 집에서 조를 만난 수잔은 깜짝 놀랐으나 곧 그에게 사랑을 느끼고 조 역시 그녀에게 끌리게 된다. 저승사자의 부름에 인생을 정리하던 빌은 회사 합병을 하지 않기로 하고 이사회에 그의 뜻을 밝히지만 그의 오른팔 드류는 야심에 불타 이사회를 조종해 빌을 해고하도록 종용한다. 빌의 딸 수잔과 사랑에 빠진 조 블랙에게 빌은 불같이 화를 내고 수잔에게 조를 멀리하라고 얘기하지만 이미 둘의 사랑은 깊어진 후였다. 조가 떠날 것이라는 것을 안 수잔은 자신을 데려가 달라고 부탁하고 조도 수잔을 깊이 사랑하여 빌과 함께 그녀를 데려가려 한다.",
            "poster_path": "/vtIVq2x8pvVVafOFMQLxWv8WwY3.jpg",
            "release_date": "1998-11-12",
            "title": "조 블랙의 사랑",
            "video": false,
            "vote_average": 7.2,
            "vote_count": 3722,
            "popularity": 29.965,
            "character": "Joe Black / Young Man in Coffee Shop",
            "credit_id": "52fe4234c3a36847f800bdbb",
            "order": 0
        },
        {
            "backdrop_path": "/3fChciF2G1wXHsyTfJD9y7uN6Il.jpg",
            "genre_ids": [
                27,
                18,
                14
            ],
            "original_language": "en",
            "original_title": "Interview with the Vampire",
            "poster_path": "/2162lAT2MP36MyJd2sttmj5du5T.jpg",
            "video": false,
            "vote_average": 7.4,
            "id": 628,
            "overview": "18세기 뉴올리언즈, 카리스마가 넘치고 퇴폐적이고 거칠것이 없는 뱀파이어 레스타트(톰 크루즈)는 루이스(브래드 피트)를 뱀파이어로 만든다. 그 삶은 죽음도 고통도 없이 영원한 젊음으로 이루어져 있으나, 신선한 피를 마시지 못하면 단 하루도 버틸 수 없는 뱀파이어의 삶. 인간적인 마음 때문에 사람의 피를 거부하던 루이는, 어느날 엄마를 잃은 고아 소녀 클로디아를 만나 끌리게 된다. 레스타트는 루이의 마음을 알고 그녀를 또 하나의 뱀파이어로 만들어 셋이서 가족을 이루는데...",
            "release_date": "1994-11-11",
            "vote_count": 4458,
            "title": "뱀파이어와의 인터뷰",
            "adult": false,
            "popularity": 36.308,
            "character": "Louis de Pointe du Lac",
            "credit_id": "52fe4260c3a36847f80199f9",
            "order": 0
        },
        {
            "adult": false,
            "backdrop_path": "/vXMn5Acau1pW9hzun5P4yM7hQ6r.jpg",
            "genre_ids": [
                12,
                36,
                10752
            ],
            "id": 652,
            "original_language": "en",
            "original_title": "Troy",
            "overview": "고대 그리스 시대, 가장 잔인하고 불운한 사랑에 빠지고 만 비련의 두 주인공 트로이의 왕자 파리스와 스파르타의 왕비 헬레네. 사랑에 눈 먼 두 남녀는 트로이로 도주하고, 파리스에게 아내를 빼앗긴 스파르타의 왕 메넬라오스는 미케네의 왕이자 자신의 형인 아가멤논에게 복수를 부탁한다. 아가멤논은 그리스 도시 국가들을 규합해 트로이로부터 헬레네를 되찾기 위한 전쟁을 일으킨다. 그러나 전쟁의 명분은 동생의 복수였지만, 진짜 이유는 모든 도시 국가들을 통합하여 거대한 그리스 제국을 건설하려는 야심이었다.",
            "poster_path": "/1TsdNMKodmOKyo4xPacxq7opo3p.jpg",
            "release_date": "2004-05-03",
            "title": "트로이",
            "video": false,
            "vote_average": 7.1,
            "vote_count": 8192,
            "popularity": 64.546,
            "character": "Achilles",
            "credit_id": "52fe4264c3a36847f801b083",
            "order": 0
        },
''';
