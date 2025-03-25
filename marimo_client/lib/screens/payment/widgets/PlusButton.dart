// PlusButton.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key});

  void _showAddEntryDialog(BuildContext context) {
    String selectedCategory = '주유';
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('지출 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items:
                      ['주유', '정비', '세차']
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) selectedCategory = value;
                  },
                ),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: '금액 입력'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final amount = int.tryParse(controller.text);
                  if (amount != null) {
                    Provider.of<CarPaymentProvider>(
                      context,
                      listen: false,
                    ).addEntry(
                      CarPaymentEntry(
                        category: selectedCategory,
                        amount: amount,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('추가'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddEntryDialog(context),
      backgroundColor: Color(0xFF4888FF),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
