import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet_balance.dart';
import '../../domain/usecases/get_wallet_transactions.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalance getWalletBalance;
  final GetWalletTransactions getWalletTransactions;

  WalletBloc({
    required this.getWalletBalance,
    required this.getWalletTransactions,
  }) : super(WalletInitial()) {
    on<FetchWalletDataEvent>(_onFetchWalletData);
  }

  Future<void> _onFetchWalletData(
    FetchWalletDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final balance = await getWalletBalance();
      final transactions = await getWalletTransactions();
      emit(WalletLoaded(balance: balance, transactions: transactions));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }
}
