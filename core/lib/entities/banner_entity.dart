import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String image;
  final bool isActive;
  final DateTime createdAt;

  const BannerEntity({
    required this.id,
    required this.image,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, image, isActive];
}
