import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../data/models/transaction_model.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Box<TransactionModel> transactionBox;

  TransactionBloc(this.transactionBox) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
  }

  void _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) {
    try {
      emit(TransactionLoading());
      final transactions = transactionBox.values.toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError('Gagal memuat transaksi: $e'));
    }
  }

  void _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) {
    try {
      transactionBox.put(event.transaction.id, event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError('Gagal menambah transaksi: $e'));
    }
  }
}