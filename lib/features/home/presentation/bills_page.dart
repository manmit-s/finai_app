import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/bill_provider.dart';
import 'package:finai/providers/user_data.dart';
import 'package:finai/models/bill.dart';
import 'package:intl/intl.dart';

/// Bills page - View and manage upcoming bills
class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddBillDialog() {
    showDialog(context: context, builder: (context) => const _AddBillDialog());
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pending'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${billProvider.pendingBillsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Tab(text: 'Paid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending Bills
          _buildBillsList(billProvider.pendingBills, userData, isPending: true),
          // Paid Bills
          _buildBillsList(billProvider.paidBills, userData, isPending: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBillDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Bill'),
      ),
    );
  }

  Widget _buildBillsList(
    List<Bill> bills,
    UserData userData, {
    required bool isPending,
  }) {
    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending
                  ? Icons.check_circle_outline
                  : Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No pending bills!' : 'No paid bills yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _BillCard(
          bill: bill,
          userData: userData,
          onTap: () => _showBillDetails(bill),
        );
      },
    );
  }

  void _showBillDetails(Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _BillDetailsSheet(bill: bill),
    );
  }
}

/// Bill card widget
class _BillCard extends StatelessWidget {
  final Bill bill;
  final UserData userData;
  final VoidCallback onTap;

  const _BillCard({
    required this.bill,
    required this.userData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilDue = bill.daysUntilDue;
    final isOverdue = bill.isOverdue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bill.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(bill.icon, color: bill.color, size: 24),
              ),
              const SizedBox(width: 16),

              // Bill info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: isOverdue
                              ? Colors.red
                              : daysUntilDue <= 3
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOverdue
                              ? 'Overdue by ${-daysUntilDue} days'
                              : daysUntilDue == 0
                              ? 'Due today'
                              : 'Due in $daysUntilDue days',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isOverdue
                                    ? Colors.red
                                    : daysUntilDue <= 3
                                    ? Colors.orange
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bill.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userData.formatCurrency(bill.amount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bill.isPaid
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (bill.isPaid)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PAID',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bill details bottom sheet
class _BillDetailsSheet extends StatelessWidget {
  final Bill bill;

  const _BillDetailsSheet({required this.bill});

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    final userData = Provider.of<UserData>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bill.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(bill.icon, color: bill.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      bill.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailRow(
            icon: Icons.attach_money,
            label: 'Amount',
            value: userData.formatCurrency(bill.amount),
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Due Date',
            value: DateFormat('MMM dd, yyyy').format(bill.dueDate),
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: bill.isPaid
                ? 'Paid'
                : bill.isOverdue
                ? 'Overdue'
                : 'Pending',
            valueColor: bill.isPaid
                ? const Color(0xFF4CAF50)
                : bill.isOverdue
                ? Colors.red
                : Colors.orange,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (!bill.isPaid)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      billProvider.markAsPaid(bill.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${bill.name} marked as paid'),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              if (!bill.isPaid) const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Bill'),
                        content: Text(
                          'Are you sure you want to delete ${bill.name}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              billProvider.deleteBill(bill.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bill deleted')),
                              );
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// Add bill dialog
class _AddBillDialog extends StatefulWidget {
  const _AddBillDialog();

  @override
  State<_AddBillDialog> createState() => _AddBillDialogState();
}

class _AddBillDialogState extends State<_AddBillDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _category = 'Utilities';
  IconData _icon = Icons.receipt_long_outlined;
  Color _color = const Color(0xFF2196F3);

  final Map<String, IconData> _categoryIcons = {
    'Utilities': Icons.bolt_outlined,
    'Entertainment': Icons.movie_outlined,
    'Insurance': Icons.shield_outlined,
    'Rent': Icons.home_outlined,
    'Phone': Icons.phone_outlined,
    'Internet': Icons.wifi_outlined,
    'Other': Icons.receipt_long_outlined,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addBill() {
    if (_formKey.currentState!.validate()) {
      final billProvider = Provider.of<BillProvider>(context, listen: false);

      final bill = Bill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        dueDate: _dueDate,
        category: _category,
        icon: _icon,
        color: _color,
      );

      billProvider.addBill(bill);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${bill.name} added successfully'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Bill'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Bill Name',
                  hintText: 'e.g., Netflix, Electricity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bill name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categoryIcons.keys.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_categoryIcons[category], size: 20),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                    _icon = _categoryIcons[value]!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _dueDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _addBill, child: const Text('Add Bill')),
      ],
    );
  }
}
