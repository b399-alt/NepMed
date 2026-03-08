import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class SearchMedicinesUseCase implements UseCase<List<MedicineEntity>, SearchParams> {
  final MedicineRepository repository;
  SearchMedicinesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(SearchParams params) =>
      repository.searchMedicines(params.query);
}

class SearchParams extends Equatable {
  final String query;
  const SearchParams(this.query);
  @override
  List<Object?> get props => [query];
}
