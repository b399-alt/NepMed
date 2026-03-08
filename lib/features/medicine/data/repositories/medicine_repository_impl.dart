import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/medicine_entity.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';
import '../models/medicine_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;
  MedicineRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<MedicineEntity>>> getMedicines() async {
    try {
      final models = await localDataSource.getMedicines();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> getMedicineById(String id) async {
    try {
      final model = await localDataSource.getMedicineById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> searchMedicines(String query) async {
    try {
      final models = await localDataSource.searchMedicines(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> addMedicine(MedicineEntity medicine) async {
    try {
      final model = MedicineModel.fromEntity(medicine);
      final result = await localDataSource.addMedicine(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> updateMedicine(MedicineEntity medicine) async {
    try {
      final model = MedicineModel.fromEntity(medicine);
      final result = await localDataSource.updateMedicine(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedicine(String id) async {
    try {
      await localDataSource.deleteMedicine(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
