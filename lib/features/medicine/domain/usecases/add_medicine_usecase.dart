import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class AddMedicineUseCase implements UseCase<MedicineEntity, AddMedicineParams> {
  final MedicineRepository repository;
  AddMedicineUseCase(this.repository);

  @override
  Future<Either<Failure, MedicineEntity>> call(AddMedicineParams params) =>
      repository.addMedicine(params.medicine);
}

class AddMedicineParams extends Equatable {
  final MedicineEntity medicine;
  const AddMedicineParams(this.medicine);
  @override
  List<Object?> get props => [medicine];
}
