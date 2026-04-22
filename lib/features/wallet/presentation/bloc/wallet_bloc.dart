import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/wallet/domain/usecases/get_wallet_balance.dart';
import 'package:zinko_app/features/wallet/domain/usecases/get_wallet_transactions.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalance getWalletBalance;
  final GetWalletTransactions getWalletTransactions;

  WalletBloc({
    required this.getWalletBalance,
    required this.getWalletTransactions,
  }) : super(WalletInitial()) {
    on<FetchWalletDataEvent>(_onFetchWalletData);
    on<ResetWalletEvent>(_onResetWallet);
  }

  void _onResetWallet(ResetWalletEvent event, Emitter<WalletState> emit) {
    emit(WalletInitial());
  }

  Future<void> _onFetchWalletData(
    FetchWalletDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    
    final balanceResult = await getWalletBalance();
    final transactionsResult = await getWalletTransactions();

    balanceResult.fold(
      (failure) => emit(WalletError(message: failure.message)),
      (balance) {
        transactionsResult.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (transactions) => emit(WalletLoaded(balance: balance, transactions: transactions)),
        );
      },
    );
  }
}
