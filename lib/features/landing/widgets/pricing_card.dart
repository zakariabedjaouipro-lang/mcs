/// Pricing card widget - displays a single pricing plan.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/landing/screens/pricing_screen.dart';

class PricingCard extends StatefulWidget {
  const PricingCard({
    super.key,
    required this.plan,
    required this.currency,
    required this.billingPeriod,
    required this.isPopular,
    required this.onGetStarted,
  });
  final PricingPlan plan;
  final String currency;
  final BillingPeriod billingPeriod;
  final bool isPopular;
  final VoidCallback onGetStarted;

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final discount = _getDiscount();
    final price = widget.plan.getPriceForPeriod(widget.billingPeriod, discount);
    final currencySymbol = _getCurrencySymbol();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0, _isHovered && !widget.isPopular ? 4 : 0),
        child: Card(
          elevation: widget.isPopular
              ? 8
              : _isHovered
                  ? 4
                  : 1,
          color: widget.isPopular
              ? AppColors.primary.withValues(alpha: 0.05)
              : null,
          child: Stack(
            children: [
              // Popular badge
              if (widget.isPopular)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'POPULAR',
                      style: TextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan name
                    Text(
                      widget.plan.name,
                      style: TextStyles.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      widget.plan.description,
                      style: TextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currencySymbol,
                          style: TextStyles.bodyLarge,
                        ),
                        Text(
                          price.toStringAsFixed(0),
                          style: TextStyles.headlineLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/${widget.billingPeriod.displayName}',
                          style: TextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Discount badge
                    if (discount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Save $discount% off monthly price',
                          style: TextStyles.labelSmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Get started button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onGetStarted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isPopular
                              ? AppColors.primary
                              : Colors.grey[300],
                          foregroundColor:
                              widget.isPopular ? Colors.white : Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Features list
                    Text(
                      'Includes:',
                      style: TextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Features
                    ...widget.plan.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get discount for current billing period.
  int _getDiscount() {
    switch (widget.billingPeriod) {
      case BillingPeriod.monthly:
        return 0;
      case BillingPeriod.quarterly:
        return 5;
      case BillingPeriod.semiAnnual:
        return 10;
      case BillingPeriod.annual:
        return 20;
    }
  }

  /// Get currency symbol.
  String _getCurrencySymbol() {
    switch (widget.currency) {
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      case 'DZD':
        return 'دج';
      default:
        return r'$';
    }
  }
}
