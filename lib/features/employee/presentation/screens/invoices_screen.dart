import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

/// Invoices Screen
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('invoices')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new invoice
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translateSafe('search_invoices'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildInvoicesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getInvoices().length,
      itemBuilder: (context, index) {
        final invoice = _getInvoices()[index];
        return _buildInvoiceCard(context, invoice);
      },
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice) {
    var statusColor = _getStatusColor(context, invoice.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${invoice.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    invoice.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice.patientName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${context.translateSafe('date')}: ${invoice.date.day}/${invoice.date.month}/${invoice.date.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${context.translateSafe('total')}: ${invoice.currency} ${invoice.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInvoiceItems(invoice.items),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(context.translateSafe('view_details')),
                    onPressed: () {
                      // View invoice details
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download, size: 16),
                    label: Text(context.translateSafe('download')),
                    onPressed: () {
                      // Download invoice
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItems(List<InvoiceItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translateSafe('items'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.take(3).map(_buildInvoiceItem),
        if (items.length > 3)
          Text(
            '+${items.length - 3} ${context.translateSafe('more_items')}',
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildInvoiceItem(InvoiceItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              item.unitPrice.toStringAsFixed(2),
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}

// Mock data classes
class Invoice {
  Invoice({
    required this.id,
    required this.patientName,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.items,
  });
  final String id;
  final String patientName;
  final DateTime date;
  final String status;
  final double totalAmount;
  final String currency;
  final List<InvoiceItem> items;
}

class InvoiceItem {
  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
  final String name;
  final int quantity;
  final double unitPrice;
}

List<Invoice> _getInvoices() {
  return [
    Invoice(
      id: 'INV-001',
      patientName: 'Ahmed Ali',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Paid',
      totalAmount: 150,
      currency: 'AED',
      items: [
        InvoiceItem(name: 'Consultation Fee', quantity: 1, unitPrice: 100),
        InvoiceItem(name: 'Prescription', quantity: 1, unitPrice: 50),
      ],
    ),
    Invoice(
      id: 'INV-002',
      patientName: 'Fatima Mohamed',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Pending',
      totalAmount: 75,
      currency: 'AED',
      items: [
        InvoiceItem(name: 'Lab Test', quantity: 1, unitPrice: 75),
      ],
    ),
    Invoice(
      id: 'INV-003',
      patientName: 'Omar Hassan',
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Overdue',
      totalAmount: 200,
      currency: 'AED',
      items: [
        InvoiceItem(
            name: 'Specialist Consultation', quantity: 1, unitPrice: 150),
        InvoiceItem(name: 'Medication', quantity: 1, unitPrice: 50),
      ],
    ),
  ];
}
