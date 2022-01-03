import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/model/movie.dart';

void main() {
  group('TMDB api를 테스트 합니다.', () {
    test('현재 상영중인 영화정보를 가져옵니다.', () async {
      final api = TMDBApi();

      final movieList = await api.fetchNowPlayingMovies();

      expect(movieList, Movie.listToMovies(jsonDecode(fakeJson)['results']));
    });
  });
}

String fakeJson = '''
{
    "dates": {
        "maximum": "2022-01-04",
        "minimum": "2021-11-17"
    },
    "page": 1,
    "results": [
        {
            "adult": false,
            "backdrop_path": "/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg",
            "genre_ids": [
                28,
                12,
                878
            ],
            "id": 634649,
            "original_language": "en",
            "original_title": "Spider-Man: No Way Home",
            "overview": "정체가 탄로난 스파이더맨 피터 파커가 시간을 되돌리기 위해 닥터 스트레인지의 도움을 받던 중 뜻하지 않게 멀티버스가 열리게 되고, 이를 통해 자신의 숙적 닥터 옥토퍼스가 나타나며 사상 최악의 위기를 맞게 되는데...",
            "popularity": 11671.933,
            "poster_path": "/voddFVdjUoAtfoZZp2RUmuZILDI.jpg",
            "release_date": "2021-12-15",
            "title": "스파이더맨: 노 웨이 홈",
            "video": false,
            "vote_average": 8.4,
            "vote_count": 2893
        },
        {
            "adult": false,
            "backdrop_path": "/3G1Q5xF40HkUBJXxt2DQgQzKTp5.jpg",
            "genre_ids": [
                16,
                35,
                10751,
                14
            ],
            "id": 568124,
            "original_language": "en",
            "original_title": "Encanto",
            "overview": "콜롬비아의 깊은 산 속, 놀라운 마법과 활기찬 매력이 넘치는 세계 엔칸토. 그 곳에는 특별한 능력을 지닌 마드리갈 패밀리가 살고 있다. 하지만 미라벨은 가족 중 유일하게 아무런 능력이 없다. 어느 날, 엔칸토를 둘러싼 마법의 힘이 위험에 처하자 미라벨은 유일하게 평범한 자신이 특별한 이 가족의 마지막 희망일지 모른다고 생각하는데...",
            "popularity": 10104.642,
            "poster_path": "/b8gz7UKMwMz39mz6EH5Jjicjdth.jpg",
            "release_date": "2021-11-24",
            "title": "엔칸토: 마법의 세계",
            "video": false,
            "vote_average": 7.8,
            "vote_count": 1315
        },
        {
            "adult": false,
            "backdrop_path": "/hv7o3VgfsairBoQFAawgaQ4cR1m.jpg",
            "genre_ids": [
                28,
                878
            ],
            "id": 624860,
            "original_language": "en",
            "original_title": "The Matrix Resurrections",
            "overview": "토마스 앤더슨은 자신의 현실이 물리적 구성개념인지 아니면 정신적 구성개념인지 알아내기 위해 이번에도 흰 토끼를 따라가야 한다. 토마스, 아니 네오가 배운 게 있다면 비록 환상이라 할지라도 선택이야말로 매트릭스를 탈출할 유일한 길이라는 것이다. 물론 네오는 무엇을 해야 할지 이미 알고 있다. 그가 아직 모르는 사실은 이 새로운 버전의 매트릭스가 그 어느 때보다도 강력하고, 확고부동하고, 위험하다는 것이다.  평범한 일상과 그 이면에 놓여 있는 또 다른 세계, 두 개의 현실이 존재하는 세상에서 운명처럼 인류를 위해 다시 깨어난 구원자 네오. 빨간 약과 파란 약 중 어떤 것을 선택할 것인가?",
            "popularity": 10571.187,
            "poster_path": "/AvWlbyLk32HdvSrrSTYpjmXHEXC.jpg",
            "release_date": "2021-12-16",
            "title": "매트릭스: 리저렉션",
            "video": false,
            "vote_average": 7.3,
            "vote_count": 1213
        },
        {
            "adult": false,
            "backdrop_path": "/o76ZDm8PS9791XiuieNB93UZcRV.jpg",
            "genre_ids": [
                27,
                28,
                878
            ],
            "id": 460458,
            "original_language": "en",
            "original_title": "Resident Evil: Welcome to Raccoon City",
            "overview": "거대 제약회사 '엄브렐라'가 철수한 후 폐허가 된 '라쿤시티'. 어릴 적 끔찍한 사건을 겪고 고향을 떠났던 클레어가 돌아온 그날 밤, 라쿤시티는 좀비 바이러스에 감염되어 순식간에 지옥으로 돌변한다. 남은 시간은 7시간, 죽음의 도시를 탈출하라!",
            "popularity": 9666.967,
            "poster_path": "/sR3iV0Jt080jgvPBtJhs3Tta1y9.jpg",
            "release_date": "2021-11-24",
            "title": "레지던트 이블: 라쿤시티",
            "video": false,
            "vote_average": 6.2,
            "vote_count": 517
        },
        {
            "adult": false,
            "backdrop_path": "/eENEf62tMXbhyVvdcXlnQz2wcuT.jpg",
            "genre_ids": [
                878,
                28,
                12
            ],
            "id": 580489,
            "original_language": "en",
            "original_title": "Venom: Let There Be Carnage",
            "overview": "‘베놈'과 완벽한 파트너가 된 ‘에디 브록' 앞에 ‘클리터스 캐서디'가 ‘카니지'로 등장, 앞으로 닥칠 대혼돈의 세상을 예고한다. 대혼돈의 시대가 시작되고, 악을 악으로 처단할 것인가?",
            "popularity": 5807.524,
            "poster_path": "/1Lh9LER4xRQ3INFFi2dfS2hpRwv.jpg",
            "release_date": "2021-09-30",
            "title": "베놈 2: 렛 데어 비 카니지",
            "video": false,
            "vote_average": 7.2,
            "vote_count": 5268
        },
        {
            "adult": false,
            "backdrop_path": "/1Wlwnhn5sXUIwlxpJgWszT622PS.jpg",
            "genre_ids": [
                16,
                35,
                10751
            ],
            "id": 585245,
            "original_language": "en",
            "original_title": "Clifford the Big Red Dog",
            "overview": "뉴욕의 아파트로 이사 온 12살 소녀 에밀리. 새로운 학교에 고군분투하는 에밀리를 바쁜 엄마는 출장을 가면서 철없는 삼촌 케이시에게 맡기고 떠난다.  마법 동물 구조 센터를 지나던 에밀리는 운명처럼 작고 빨간 강아지를 만나게 되고, 우여곡절 끝에 함께하게 된다. 하지만 기쁨도 잠시, 작고 빨간 강아지 클리포드는 하루 아침에 3M가 넘게 커져버려 순식간에 뉴욕의 유명인사가 되어버린다. 엄마가 오기 전 클리포드를 되돌리려는 에밀리와 클리포드를 유전학 사업에 이용하려는 기업까지 뒤쫓으며 클리포드는 위험에 빠지고 마는데..!",
            "popularity": 1951.664,
            "poster_path": "/mJwwkMKeR5XgHwexw9SJa6CiZY2.jpg",
            "release_date": "2021-11-10",
            "title": "클리포드 더 빅 레드 독",
            "video": false,
            "vote_average": 7.4,
            "vote_count": 730
        },
        {
            "adult": false,
            "backdrop_path": "/zlj0zHo67xXoj7hvwGtaKRkSdBV.jpg",
            "genre_ids": [
                878,
                53,
                12
            ],
            "id": 728526,
            "original_language": "en",
            "original_title": "Encounter",
            "overview": "우주의 유성이 지구로 떨어진 어느 날, 정신을 조종하는 외계 기생충이 지구에 퍼지기 시작한다. 외계 기생충에 관한 일급 기밀 정보를 입수한 해병 특수대원 말릭은 두 아들 제이와 보비를 구하기 위해 2년 만에 피야의 집으로 향한다. 말릭은 차고에 전처 피야와 딜런을 묶어 놓고 10살 제이, 8살 보비와 함께 치료제가 개발 중인 네바다의 그룸 레이크 기지로 출발한다. 얼마 후 웨스트 보안관이 말릭을 검문하고, 보안관의 눈에서 기생충을 본 말릭은 그를 쓰러뜨리고 달아난다. 말릭은 지구를 침공한 외계 미생물이 인류의 반을 점령했다고 제이와 보비에게 알려준다. 그리고 가석방 담당자 해티에게 전화해서 차고에 있는 피야를 도와달라고 부탁한다. 해티는 아동 유괴 전담 FBI 특수 요원 셰퍼드와 랜스에게 말릭이 상관을 구타하고 2년 동안 수감되어 있었다는 사실을 진술한다. 말릭에게 1만 달러의 현상금이 내걸리고 셰퍼드와 랜스는 제이와 보비의 구출 작전을 시작하는데...",
            "popularity": 1631.739,
            "poster_path": "/AjRUsn8m2znK4mQuYR5fUguBDQM.jpg",
            "release_date": "2021-12-03",
            "title": "엔카운터",
            "video": false,
            "vote_average": 6.3,
            "vote_count": 145
        },
        {
            "adult": false,
            "backdrop_path": "/srFi3oLy8tBcpq07xusnAE5XhwE.jpg",
            "genre_ids": [
                16,
                35,
                10751,
                10402
            ],
            "id": 438695,
            "original_language": "en",
            "original_title": "Sing 2",
            "overview": "대국민 오디션 이후 각자의 자리에서 꿈을 이루고 있는 버스터 문(매튜 맥커너히)과 크루들에게 레드 쇼어 시티에서 전 세계가 주목하는 사상 최고의 쇼가 펼쳐진다는 소식이 들려오고 버스터 문과 크루들은 도전에 나선다. 그러나 최고의 스테이지에 서기 위한 경쟁은 이전과는 비교도 할 수 없을 만큼 치열하고, 버스터 문은 완벽한 라이브를 위해 종적을 감춘 레전드 뮤지션 클레이(보노)를 캐스팅하겠다는 파격 선언을 하는데!",
            "popularity": 1737.128,
            "poster_path": "/xe8dVB2QiCxLWFV77V4dpZcOvYB.jpg",
            "release_date": "2021-12-01",
            "title": "씽2게더",
            "video": false,
            "vote_average": 7.7,
            "vote_count": 75
        },
        {
            "adult": false,
            "backdrop_path": "/5B22eed7ErxFiYAG4Ksb4eLwKNF.jpg",
            "genre_ids": [
                16,
                12,
                35,
                10751
            ],
            "id": 770254,
            "original_language": "en",
            "original_title": "Back to the Outback",
            "overview": "야생동물 공원을 탈출한 따뜻한 마음씨를 가진 동물 친구들이 '프리티 보이'라는 유명 코알라와 함께, 호주 동물들의 유토피아인 '아웃백'으로 떠나며 추격전이 시작된다는 내용을 다룬 애니메이션",
            "popularity": 1482.08,
            "poster_path": "/zNXNRLH5wJprUG6B1olaBTNZOjy.jpg",
            "release_date": "2021-12-03",
            "title": "우리 함께 아웃백으로!",
            "video": false,
            "vote_average": 7.7,
            "vote_count": 160
        },
        {
            "adult": false,
            "backdrop_path": "/mFbS5TwN95BcSEfiztdchLgTQ0v.jpg",
            "genre_ids": [
                28,
                18,
                36
            ],
            "id": 617653,
            "original_language": "en",
            "original_title": "The Last Duel",
            "overview": "부조리한 권력과 야만의 시대, 14세기 프랑스. 장(맷 데이먼)은 영주 피에르(벤 애플렉)의 총애를 받는 자크(애덤 드라이버)에게 불만을 품고 있다. 그러다 피에르에 의해 마르그리트(조디 코머)의 결혼 지참금인 토지를 자크에게 빼앗기게 되자 자크에 대한 적대감이 극에 달한다. 한편 마르그리트에게 첫눈에 반한 자크는 장이 집을 비운 사이 마르그리트를 찾아가 겁탈한다. 용서받지 못할 짓을 저지른 자크는 마르그리트에게 침묵을 강요하지만, 마르그리트는 자신이 입을 여는 순간 감내해야 할 불명예를 각오하고 용기를 내어 자크의 죄를 고발한다. 강간사건에 대한 재판이 시작되고, 서로의 입장이 맹렬히 충돌하면서 파열음을 낸다. 결국 한때 전우였던 장과 자크는 승리한 자가 무죄, 패한 자가 유죄가 되는 결투 재판에서 승부를 겨루게 되는데...",
            "popularity": 1476.138,
            "poster_path": "/zPDY58lk0YIxr9qsnGV64PEnjkI.jpg",
            "release_date": "2021-10-13",
            "title": "라스트 듀얼: 최후의 결투",
            "video": false,
            "vote_average": 7.6,
            "vote_count": 1160
        },
        {
            "adult": false,
            "backdrop_path": "/9fzNf2QcsHVvdx5g5QUOgAWpADw.jpg",
            "genre_ids": [
                18,
                27,
                9648
            ],
            "id": 516329,
            "original_language": "en",
            "original_title": "Antlers",
            "overview": "오레곤 주의 작은 마을 선생님과 그녀의 오빠, 지역 보안관은 위험한 비밀을 숨기고 있는 어린 학생과 끔찍한 결과를 초래한다",
            "popularity": 1127.206,
            "poster_path": "/cMch3tiexw3FdOEeZxMWVel61Xg.jpg",
            "release_date": "2021-10-28",
            "title": "앤틀러스",
            "video": false,
            "vote_average": 6.4,
            "vote_count": 204
        },
        {
            "adult": false,
            "backdrop_path": "/nE2VnpDhlfG9NXhuzs4yFHilUSU.jpg",
            "genre_ids": [
                80,
                18,
                53
            ],
            "id": 656991,
            "original_language": "en",
            "original_title": "Wild Indian",
            "overview": "",
            "popularity": 1130.494,
            "poster_path": "/yhOpkNvgW1ZzmEpR4iqxKwKKShL.jpg",
            "release_date": "2021-09-03",
            "title": "와일드 인디언",
            "video": false,
            "vote_average": 6.7,
            "vote_count": 8
        },
        {
            "adult": false,
            "backdrop_path": "/mRZDHjArYNWpOv06kxRK1cduQKh.jpg",
            "genre_ids": [
                27,
                53
            ],
            "id": 754934,
            "original_language": "en",
            "original_title": "Son",
            "overview": "사이비 종교의 추종자들이 로라의 집에 침입하여 여덟 살 난 아들 데이비드를 훔치려하자 두 사람은 안전을 찾아 마을을 떠난다. 그러나 납치 실패 직후 데이비드는 극심한 병에 걸려 점점 산발적인 정신병과 경련으로 고통 받는다. 로라는 아들을 구하려는 모성 본능에 따라 그를 살리기 위해 사력을 다하는데...",
            "popularity": 1204.988,
            "poster_path": "/4fl6EdtMp6p0RKJgESdFti1J3dC.jpg",
            "release_date": "2021-08-06",
            "title": "선",
            "video": false,
            "vote_average": 6.4,
            "vote_count": 46
        },
        {
            "adult": false,
            "backdrop_path": "/r2GAjd4rNOHJh6i6Y0FntmYuPQW.jpg",
            "genre_ids": [
                12,
                28,
                53
            ],
            "id": 370172,
            "original_language": "en",
            "original_title": "No Time to Die",
            "overview": "MI6를 떠난 이후 매들린(레아 세두)과 이탈리아의 오랜 도시 마테라에서 평화로운 일상을 즐기던 제임스 본드(대니엘 크레이그).  어느 날 CIA 요원 펠릭스(제프리 라이트)가 찾아와 선별적 DNA 공격이 가능한 새로운 형태의 생화학 무기 유출을 알린다. 위험에 처한 전 세계를 구하기 위해 복귀하게 된 제임스 본드는 임무를 수행하는 과정에서 새로운 MI6 요원 노미(라샤나 린치)를 만나고, 모든 사건의 배후에 운명으로 얽혀 있는 최악의 적 사핀(라미 말렉)이 존재한다는 것을 알아낸다. 위험천만한 위기 속, 감춰져 있던 비밀이 밝혀지면서 작전은 점점 더 예측할 수 없는 상황으로 치닫게 되는데...",
            "popularity": 1082.876,
            "poster_path": "/68ZwnPALUeweaFdT1z75oXJ4Xie.jpg",
            "release_date": "2021-09-29",
            "title": "007 노 타임 투 다이",
            "video": false,
            "vote_average": 7.5,
            "vote_count": 2837
        },
        {
            "adult": false,
            "backdrop_path": "/upOi9aVqPPky7Ba4GsiyFdjc82I.jpg",
            "genre_ids": [
                37,
                28,
                53
            ],
            "id": 887767,
            "original_language": "fr",
            "original_title": "Last Shoot Out",
            "overview": "신혼부부는 남편이 아버지를 총에 맞아 쓰러뜨렸다는 사실을 알게 된 직후 두려움에 떨며 캘러한 목장에서 도망친다. 그녀는 남편이 신부를 되찾으려는 시도를 막는 동안 외딴 전초기지에서 그녀를 지켜주는 총잡이에 의해 구출된다.",
            "popularity": 943.142,
            "poster_path": "/pvEtPxotI3POlVPvNxgrHJuDXfe.jpg",
            "release_date": "2021-12-03",
            "title": "마지막 총격전",
            "video": false,
            "vote_average": 6.5,
            "vote_count": 55
        },
        {
            "adult": false,
            "backdrop_path": "/jYEW5xZkZk2WTrdbMGAPFuBqbDc.jpg",
            "genre_ids": [
                878,
                12
            ],
            "id": 438631,
            "original_language": "en",
            "original_title": "Dune",
            "overview": "10191년, 아트레이데스 가문의 후계자인 폴은 시간과 공간을 초월해 과거와 미래를 모두 볼 수 있고, 더 나은 미래를 만들 유일한 구원자인 예지된 자의 운명을 타고났다. 그리고 어떤 계시처럼 매일 꿈에서 아라키스의 행성에 있는 한 여인을 만난다. 귀족들이 지지하는 아트레이데스 가문에 대한 황제의 질투는 폴과 그 일족들을 죽음이 기다리는 아라키스로 이끄는데...",
            "popularity": 937.941,
            "poster_path": "/Dtwad1HQv3jc2f54QQQHJ1VZ1W.jpg",
            "release_date": "2021-09-15",
            "title": "듄",
            "video": false,
            "vote_average": 7.9,
            "vote_count": 5044
        },
        {
            "adult": false,
            "backdrop_path": "/uWGPC7j70LE64nbetxQGSSYJO53.jpg",
            "genre_ids": [
                53,
                10752
            ],
            "id": 762433,
            "original_language": "en",
            "original_title": "Zeros and Ones",
            "overview": "",
            "popularity": 758.184,
            "poster_path": "/sopFsYj2yaKXVsBRVAPcNlqTLY5.jpg",
            "release_date": "2021-11-18",
            "title": "제로스 앤 원스",
            "video": false,
            "vote_average": 5.6,
            "vote_count": 89
        },
        {
            "adult": false,
            "backdrop_path": "/akwg1s7hV5ljeSYFfkw7hTHjVqk.jpg",
            "genre_ids": [
                16,
                35,
                12,
                10751
            ],
            "id": 459151,
            "original_language": "en",
            "original_title": "The Boss Baby: Family Business",
            "overview": "베이비 주식회사의 레전드 보스 베이비에서 인생 만렙 CEO가 된 `테드`. 베이비인 줄 알았던 조카 `티나`가 알고 보니 베이비 주식회사 소속이라니! 뉴 보스 베이비 `티나`의 지시로 `테드`는 형과 함께 다시 베이비로 돌아가야만 하는데…",
            "popularity": 750.567,
            "poster_path": "/zGaeo3fNXCcnttUQMgZr1FW0t4V.jpg",
            "release_date": "2021-07-01",
            "title": "보스 베이비 2",
            "video": false,
            "vote_average": 7.7,
            "vote_count": 1675
        },
        {
            "adult": false,
            "backdrop_path": "/4VL5C8s3y2efpB03SvCD3eFxg1i.jpg",
            "genre_ids": [
                35,
                10751
            ],
            "id": 755437,
            "original_language": "es",
            "original_title": "Mamá o papá",
            "overview": "",
            "popularity": 725.184,
            "poster_path": "/yo4aBPuyWh8uB2VHPwK1O7R6WwO.jpg",
            "release_date": "2021-12-17",
            "title": "Mamá o papá",
            "video": false,
            "vote_average": 7.6,
            "vote_count": 39
        },
        {
            "adult": false,
            "backdrop_path": "/1BqX34aJS5J8PefVnQSfQIEPfkl.jpg",
            "genre_ids": [
                80,
                28,
                53
            ],
            "id": 826749,
            "original_language": "en",
            "original_title": "Fortress",
            "overview": "",
            "popularity": 1034.102,
            "poster_path": "/m76LAg0MchIcIW9i4yXsQPGQJJF.jpg",
            "release_date": "2021-12-17",
            "title": "포트리스",
            "video": false,
            "vote_average": 6.6,
            "vote_count": 58
        }
    ],
    "total_pages": 96,
    "total_results": 1903
}
''';
