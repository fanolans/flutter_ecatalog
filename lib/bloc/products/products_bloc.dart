import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource datasource;
  ProductsBloc(
    this.datasource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result = await datasource.getAllProduct();
      result.fold(
        (error) => emit(
          ProductsError(message: error),
        ),
        (data) => emit(
          ProductsLoaded(data: data),
        ),
      );
    });
  }
}
