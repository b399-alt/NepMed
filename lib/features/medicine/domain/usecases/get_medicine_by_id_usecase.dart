import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class GetMedicineByIdUseCase implements UseCase<MedicineEntity, MedicineIdParams> {
  final MedicineRepository repository;
  GetMedicineByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MedicineEntity>> call(MedicineIdParams params) =>
      repository.getMedicineById(params.id);
}

class MedicineIdParams extends Equatable {
  final String id;
  const MedicineIdParams(this.id);
  @override
  List<Object?> get props => [id];
}
