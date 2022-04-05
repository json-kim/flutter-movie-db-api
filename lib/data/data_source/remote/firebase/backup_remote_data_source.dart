import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class BackupRemoteDataSource {
  final Uuid _uuid = Uuid(); // uuid 생성 객체
  final _logger = Logger(); // 로거
  final _encoder = Utf8Encoder();
  final _decoder = Utf8Decoder();

  /// 현재 인증된 유저의 uid 리턴
  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    // User == null 이면 에러
    if (currentUser == null) {
      throw Exception('currentuser is null');
    }

    return currentUser.uid;
  }

  /// 백업 데이터 서버에 저장
  Future<Result<int>> saveBackup(BackupData backupData) async {
    return ErrorApi.handleRemoteApiError(() async {
      final Map<String, dynamic> backupJson =
          backupData.toJson(); // Map 형식으로 변환
      final jsonString = jsonEncode(backupJson); // json 문자열로 변환

      final file = await _convertToFile(jsonString); // File로 변환

      final path = await _saveBackupData(file); // File 서버에 저장

      await _saveBackupItem(path); // nosql 서버에 저장

      return const Result.success(1);
    }, _logger, '$runtimeType.saveBackup()');
  }

  /// 문자열 데이터 압축된 파일로 변환
  Future<File> _convertToFile(String data) async {
    final bytes = _encoder.convert(data); // String -> uint8List

    final zippedBuffer = gzip.encode(bytes); // 버퍼 압축

    final tempDir = await getTemporaryDirectory(); // 파일 임시 경로
    final path = tempDir.path;

    final tempFile = File('$path/temp.file'); // 파일에 데이터 작성
    await tempFile.writeAsBytes(zippedBuffer);
    await tempFile.create();

    return tempFile;
  }

  /// 백업 데이터 파일 파이어스토리지에 저장
  Future<String> _saveBackupData(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance; // 파이어스토리지

    String fileName = 'backup/${_uuid.v1()}.file'; // 저장될 파일 경로
    Reference ref = storage.ref(fileName); // 파일 레퍼런스(파일명)
    await ref.putFile(file); // 파일 업로드

    await file.delete(); // 임시 파일은 삭제

    return fileName; // url 리턴
  }

  /// 백업파일url을 담은 클래스 파이어스토어에 저장
  Future<void> _saveBackupItem(String path) async {
    // 백업 데이터
    final newBackupItem = BackupItem(
      id: _uuid.v1(),
      path: path,
      uploadDate: DateTime.now(),
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance; // 파이어스토어

    final userCollection = firestore.collection('users'); // users 컬렉션

    String uid = _getUid(); // 유저 id 가져오기

    final backupCollection =
        userCollection.doc(uid).collection('backups'); // users/$uid/backups 컬렉션

    await backupCollection
        .add(newBackupItem.toJson()); // backups 컬렉션에 백업 데이터 추가
  }

  /// 백업 아이템 리스트 파이어스토어에서 가져오기
  Future<Result<List<BackupItem>>> getBackupList() async {
    return ErrorApi.handleRemoteApiError(() async {
      final firestore = FirebaseFirestore.instance; // 파이어 스토어

      final uid = _getUid(); // 인증 유저 아이디

      final userCollection = firestore.collection('users'); // 유저 컬렉션
      final backupCollection =
          userCollection.doc(uid).collection('backups'); // 현재 유저의 백업 컬렉션

      final snapshot = await backupCollection.get(); // 컬렉션 스냅샷
      final docsSnapshot = snapshot.docs; // 문서들 스냅샷
      final backupItems = docsSnapshot
          .map((docSnapshot) => BackupItem.fromJson(docSnapshot.data()))
          .toList(); // 백업 아이템으로 변환

      return Result.success(backupItems);
    }, _logger, '$runtimeType.getBackupList()');
  }

  /// 백업 데이터 경로를 가지고 백업 데이터 파이어스토리지에서 가져오기
  Future<Result<BackupData>> getBackupData(String path) async {
    return ErrorApi.handleRemoteApiError(() async {
      final tempDir = await getTemporaryDirectory();
      final filePath = tempDir.path;
      final downloadFile = File('$filePath/temp.file');
      await downloadFile.create();

      final storage = FirebaseStorage.instance;

      final fileRef = storage.ref(path);

      await fileRef.writeToFile(downloadFile);

      final fileByteList = await downloadFile.readAsBytes();
      final unZippedList = gzip.decode(fileByteList);

      final jsonString = _decoder.convert(unZippedList);

      final json = jsonDecode(jsonString);
      final backupData = BackupData.fromJson(json);

      return Result.success(backupData);
    }, _logger, '$runtimeType.getBackupData()');
  }

  /// 백업 데이터 경로를 가지고 백업 데이터 파이어스토리지에서 삭제
  Future<Result<int>> deleteBackup(BackupItem item) async {
    return ErrorApi.handleRemoteApiError(() async {
      // 먼저 백업 아이템 삭제하고 백업 데이터 삭제
      await _deleteBackupItem(item.id);

      await _deleteBackupData(item.path);

      return const Result.success(1);
    }, _logger, '$runtimeType.deleteBackup()');
  }

  Future<void> _deleteBackupItem(String id) async {
    final firestore = FirebaseFirestore.instance;

    final uid = _getUid();

    final querySnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('backups')
        .where('id', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // docReference 를 가지고 삭제해야 더미데이터가 남지 않는다.
      final docReference = querySnapshot.docs.first.reference;
      firestore.runTransaction(
          (transaction) async => transaction.delete(docReference));
    } else {
      throw Exception('해당 백업 아이템 없음');
    }
  }

  Future<void> _deleteBackupData(String path) async {
    final storage = FirebaseStorage.instance;

    final fileRef = storage.ref(path);

    await fileRef.delete();
  }
}
