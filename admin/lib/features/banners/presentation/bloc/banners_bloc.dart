import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_banners_datasource.dart';

part 'banners_event.dart';
part 'banners_state.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  final MockBannersDataSource _dataSource;

  BannersBloc({required MockBannersDataSource dataSource})
      : _dataSource = dataSource,
        super(const BannersInitial()) {
    on<BannersLoadRequested>(_onLoad);
    on<BannerCreateRequested>(_onCreate);
    on<BannerDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(BannersLoadRequested event, Emitter<BannersState> emit) async {
    emit(const BannersLoading());
    try {
      emit(BannersLoaded(await _dataSource.getBanners()));
    } catch (e) {
      emit(BannersError(e.toString()));
    }
  }

  Future<void> _onCreate(BannerCreateRequested event, Emitter<BannersState> emit) async {
    try {
      await _dataSource.createBanner(image: event.image);
      add(const BannersLoadRequested());
    } catch (e) {
      emit(BannersError(e.toString()));
    }
  }

  Future<void> _onDelete(BannerDeleteRequested event, Emitter<BannersState> emit) async {
    try {
      await _dataSource.deleteBanner(event.bannerId);
      add(const BannersLoadRequested());
    } catch (e) {
      emit(BannersError(e.toString()));
    }
  }
}
