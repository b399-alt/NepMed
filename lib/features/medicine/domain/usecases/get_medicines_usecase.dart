import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class GetMedicinesUseCase implements UseCase<List<MedicineEntity>, NoParams> {
  final MedicineRepository repository;
  GetMedicinesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(NoParams params) =>
      repository.getMedicines();
}
