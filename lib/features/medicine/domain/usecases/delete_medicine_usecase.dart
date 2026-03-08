import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/medicine_repository.dart';

class DeleteMedicineUseCase implements UseCase<void, DeleteMedicineParams> {
  final MedicineRepository repository;
  DeleteMedicineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMedicineParams params) =>
      repository.deleteMedicine(params.id);
}

class DeleteMedicineParams extends Equatable {
  final String id;
  const DeleteMedicineParams(this.id);
  @override
  List<Object?> get props => [id];
}
