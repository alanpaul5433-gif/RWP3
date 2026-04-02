part of 'customers_bloc.dart';

sealed class CustomersEvent extends Equatable {
  const CustomersEvent();
  @override
  List<Object?> get props => [];
}

class CustomersLoadRequested extends CustomersEvent {
  final int page;
  final int pageSize;
  const CustomersLoadRequested({this.page = 0, this.pageSize = 10});
  @override
  List<Object?> get props => [page, pageSize];
}

class CustomerSearchRequested extends CustomersEvent {
  final String query;
  const CustomerSearchRequested(this.query);
  @override
  List<Object?> get props => [query];
}

class CustomerDetailRequested extends CustomersEvent {
  final String customerId;
  const CustomerDetailRequested(this.customerId);
  @override
  List<Object?> get props => [customerId];
}
