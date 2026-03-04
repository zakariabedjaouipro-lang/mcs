/// Currency selector widget for changing app currency.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/services/currency_service.dart';

/// Currency selector button widget.
class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    super.key,
    this.selectedCurrency,
    this.onChanged,
    this.showLabel = false,
  });
  final Currency? selectedCurrency;
  final ValueChanged<Currency>? onChanged;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currency = selectedCurrency ?? Currency.dzd;

    return PopupMenuButton<Currency>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currency.symbol,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            currency.code,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              localizations.language,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ],
      ),
      tooltip: 'Currency',
      onSelected: (Currency newCurrency) {
        onChanged?.call(newCurrency);
      },
      itemBuilder: (BuildContext context) => Currency.values
          .map(
            (curr) => PopupMenuItem<Currency>(
              value: curr,
              child: Row(
                children: [
                  Text(
                    curr.symbol,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    curr.name,
                    style: TextStyle(
                      fontWeight: currency == curr
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${curr.code})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (currency == curr) ...[
                    const Spacer(),
                    const Icon(Icons.check, size: 18),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Simple currency switcher for use in settings pages.
class CurrencySwitcherSimple extends StatelessWidget {
  const CurrencySwitcherSimple({
    super.key,
    this.selectedCurrency,
    this.onChanged,
  });
  final Currency? selectedCurrency;
  final ValueChanged<Currency>? onChanged;

  @override
  Widget build(BuildContext context) {
    final currency = selectedCurrency ?? Currency.dzd;

    return Card(
      child: ListTile(
        leading: Text(
          currency.symbol,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: const Text('Currency'),
        subtitle: Text('${currency.name} (${currency.code})'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showCurrencyDialog(context),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currency = selectedCurrency ?? Currency.dzd;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Currency.values
              .map(
                (curr) => ListTile(
                  leading: Text(
                    curr.symbol,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(curr.name),
                  subtitle: Text(curr.code),
                  trailing:
                      currency == curr ? const Icon(Icons.check_circle) : null,
                  onTap: () {
                    Navigator.pop(context);
                    onChanged?.call(curr);
                  },
                  selected: currency == curr,
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Currency selector dropdown for forms.
class CurrencySelectorDropdown extends StatelessWidget {
  const CurrencySelectorDropdown({
    super.key,
    this.selectedCurrency,
    this.onChanged,
    this.label,
    this.hint,
  });
  final Currency? selectedCurrency;
  final ValueChanged<Currency?>? onChanged;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DropdownButtonFormField<Currency>(
      initialValue: selectedCurrency,
      decoration: InputDecoration(
        labelText: label ?? 'Currency',
        hintText: hint ?? 'Select currency',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      items: Currency.values
          .map(
            (curr) => DropdownMenuItem<Currency>(
              value: curr,
              child: Row(
                children: [
                  Text(
                    curr.symbol,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(curr.name),
                  const SizedBox(width: 8),
                  Text(
                    '(${curr.code})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return localizations.requiredField;
        }
        return null;
      },
    );
  }
}

/// Currency display widget with auto-conversion.
class CurrencyDisplay extends StatelessWidget {
  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.fromCurrency,
    this.toCurrency,
    this.style,
    this.decimalPlaces,
  });
  final double amount;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final TextStyle? style;
  final int? decimalPlaces;

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final displayCurrency = toCurrency ?? fromCurrency ?? Currency.dzd;

    // Convert amount if needed
    final convertedAmount = fromCurrency != null && toCurrency != null
        ? currencyService.convert(amount, from: fromCurrency, to: toCurrency)
        : amount;

    // Format with appropriate decimal places
    final places = decimalPlaces ?? (displayCurrency == Currency.dzd ? 3 : 2);
    final formattedAmount = convertedAmount.toStringAsFixed(places);

    return Text(
      '${displayCurrency.symbol}$formattedAmount',
      style: style,
    );
  }
}

/// Price display with original and converted prices.
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    super.key,
    required this.originalPrice,
    required this.originalCurrency,
    this.targetCurrency,
    this.originalStyle,
    this.convertedStyle,
    this.showOriginal = true,
  });
  final double originalPrice;
  final Currency originalCurrency;
  final Currency? targetCurrency;
  final TextStyle? originalStyle;
  final TextStyle? convertedStyle;
  final bool showOriginal;

  @override
  Widget build(BuildContext context) {
    final currencyService = CurrencyService();
    final displayCurrency = targetCurrency ?? originalCurrency;

    final convertedPrice = currencyService.convert(
      originalPrice,
      from: originalCurrency,
      to: displayCurrency,
    );

    final places = displayCurrency == Currency.dzd ? 3 : 2;
    final formattedOriginal = originalPrice.toStringAsFixed(places);
    final formattedConverted = convertedPrice.toStringAsFixed(places);

    if (showOriginal && originalCurrency != displayCurrency) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${originalCurrency.symbol}$formattedOriginal',
            style: originalStyle?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          Text(
            '${displayCurrency.symbol}$formattedConverted',
            style: convertedStyle,
          ),
        ],
      );
    }

    return Text(
      '${displayCurrency.symbol}$formattedConverted',
      style: convertedStyle,
    );
  }
}
