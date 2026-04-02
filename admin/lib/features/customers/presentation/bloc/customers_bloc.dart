import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_customer_datasource.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final MockCustomerDataSource _dataSource;

  CustomersBloc({required MockCustomerDataSource dataSource})
      : _dataSource = dataSource,
        super(const CustomersInitial()) {
    on<CustomersLoadRequested>(_onLoad);
    on<CustomerSearchRequested>(_onSearch);
    on<CustomerDetailRequested>(_onDetail);
  }

  Future<void> _onLoad(
    CustomersLoadRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(const CustomersLoading());
    try {
      final customers = await _dataSource.getCustomers(
        page: event.page,
        pageSize: event.pageSize,
      );
      final total = await _dataSource.getTotalCount();
      emit(CustomersLoaded(
        customers: customers,
        totalCount: total,
        currentPage: event.page,
        pageSize: event.pageSize,
      ));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> _onSearch(
    CustomerSearchRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(const CustomersLoading());
    try {
      final customers = await _dataSource.getCustomers(
        searchQuery: event.query,
      );
      emit(CustomersLoaded(
        customers: customers,
        totalCount: customers.length,
        currentPage: 0,
        pageSize: customers.length,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> _onDetail(
    CustomerDetailRequested event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      final customer = await _dataSource.getCustomer(event.customerId);
      emit(CustomerDetailLoaded(customer));
    } on ServerException catch (e) {
      emit(CustomersError(e.message));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }
}
