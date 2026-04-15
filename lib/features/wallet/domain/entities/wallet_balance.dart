import 'package:equatable/equatable.dart';

class WalletBalance extends Equatable {
  final double balance;

  const WalletBalance({required this.balance});

  @override
  List<Object?> get props => [balance];
}
