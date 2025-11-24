import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_state.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransactionError) {
            return Center(child: Text(state.message));
          }
          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('Belum ada transaksi.'));
            }
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExpansionTile(
                    title: Text(
                      'No. ${transaction.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(transaction.dateTime),
                    ),
                    trailing: Text(
                      currencyFormatter.format(transaction.totalAmount),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transaction.items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = transaction.items[itemIndex];
                          return ListTile(
                            title: Text(item.productName),
                            subtitle: Text('${item.quantity} x ${currencyFormatter.format(item.price)}'),
                            trailing: Text(
                              currencyFormatter.format(item.price * item.quantity),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Memuat data...'));
        },
      ),
    );
  }
}