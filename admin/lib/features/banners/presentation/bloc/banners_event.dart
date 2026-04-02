part of 'banners_bloc.dart';

sealed class BannersEvent extends Equatable {
  const BannersEvent();
  @override
  List<Object?> get props => [];
}

class BannersLoadRequested extends BannersEvent { const BannersLoadRequested(); }

class BannerCreateRequested extends BannersEvent {
  final String image;
  const BannerCreateRequested(this.image);
  @override
  List<Object?> get props => [image];
}

class BannerDeleteRequested extends BannersEvent {
  final String bannerId;
  const BannerDeleteRequested(this.bannerId);
  @override
  List<Object?> get props => [bannerId];
}
