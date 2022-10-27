 
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/service/save_ref_image_service.dart';
import 'package:injectable/injectable.dart';

abstract class RefImageStatusRepository {
  Future<List<SaveRefImageStatus>> getAllSaveStatus();

  Stream<List<SaveRefImageStatus>> observeAllSaveStatus();
}

@Singleton(as: RefImageStatusRepository)
class RefImageStatusRepositoryImpl implements RefImageStatusRepository {
  final SaveRefImageService _service;

  RefImageStatusRepositoryImpl(this._service);

  @override
  Future<List<SaveRefImageStatus>> getAllSaveStatus() =>
      _service.getCurrentStatus();

  @override
  Stream<List<SaveRefImageStatus>> observeAllSaveStatus() =>
      _service.observeStatus();
}
