part of 'customers_bloc.dart';

sealed class CustomersState extends Equatable {
  const CustomersState();
  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomersLoaded extends CustomersState {
  final List<UserEntity> customers;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final String? searchQuery;

  const CustomersLoaded({
    required this.customers,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    this.searchQuery,
  });

  @override
  List<Object?> get props =>
      [customers, totalCount, currentPage, pageSize, searchQuery];
}

class CustomerDetailLoaded extends CustomersState {
  final UserEntity customer;
  const CustomerDetailLoaded(this.customer);
  @override
  List<Object?> get props => [customer];
}

class CustomersError extends CustomersState {
  final String message;
  const CustomersError(this.message);
  @override
  List<Object?> get props => [message];
}
