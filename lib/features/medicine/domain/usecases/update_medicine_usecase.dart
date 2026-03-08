import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class UpdateMedicineUseCase implements UseCase<MedicineEntity, UpdateMedicineParams> {
  final MedicineRepository repository;
  UpdateMedicineUseCase(this.repository);

  @override
  Future<Either<Failure, MedicineEntity>> call(UpdateMedicineParams params) =>
      repository.updateMedicine(params.medicine);
}

class UpdateMedicineParams extends Equatable {
  final MedicineEntity medicine;
  const UpdateMedicineParams(this.medicine);
  @override
  List<Object?> get props => [medicine];
}
