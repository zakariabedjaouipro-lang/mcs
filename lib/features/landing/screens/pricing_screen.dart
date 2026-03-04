/// Pricing screen - subscription plans with currency support.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/currency_selector.dart';
import 'package:mcs/features/landing/widgets/pricing_card.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  late CurrencyController _currencyController;
  late BillingPeriod _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _currencyController = CurrencyController();
    _selectedPeriod = BillingPeriod.monthly;
    _currencyController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pricing Plans',
          style: TextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.isSmall ? 16 : 48,
          vertical: context.isSmall ? 24 : 40,
        ),
        child: Column(
          children: [
            // Introduction
            _buildIntroduction(context),
            const SizedBox(height: 40),

            // Currency selector
            Align(
              alignment: Alignment.centerRight,
              child: CurrencySelector(controller: _currencyController),
            ),
            const SizedBox(height: 24),

            // Billing period selector
            _buildBillingPeriodSelector(context),
            const SizedBox(height: 48),

            // Pricing cards
            _buildPricingCards(context),
            const SizedBox(height: 48),

            // FAQ section
            _buildFAQSection(context),
          ],
        ),
      ),
    );
  }

  /// Build introduction section.
  Widget _buildIntroduction(BuildContext context) {
    return Column(
      children: [
        Text(
          'Simple, Transparent Pricing',
          style: TextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.isSmall ? 28 : 36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Choose the perfect plan for your clinic. All plans include core features.',
          style: TextStyles.bodyLarge.copyWith(
            color: Colors.grey[600],
            fontSize: context.isSmall ? 14 : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build billing period selector (monthly, quarterly, semi-annual, annual).
  Widget _buildBillingPeriodSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: BillingPeriod.values.map((period) {
          final isSelected = _selectedPeriod == period;
          final discount = _getDiscount(period);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              children: [
                FilterChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        period.displayName,
                        style: TextStyles.labelLarge,
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Save $discount%',
                          style: TextStyles.labelSmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build pricing cards grid.
  Widget _buildPricingCards(BuildContext context) {
    final crossAxisCount = context.isSmall ? 1 : 2;
    final plans = _getPricingPlans();

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: plans
          .map(
            (plan) => PricingCard(
              plan: plan,
              currency: _currencyController.selectedCurrency,
              billingPeriod: _selectedPeriod,
              isPopular: plan.name == 'Professional',
              onGetStarted: () => _handleGetStarted(context, plan),
            ),
          )
          .toList(),
    );
  }

  /// Build FAQ section for pricing.
  Widget _buildFAQSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: TextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildFAQItem(
          question: 'Can I change plans anytime?',
          answer:
              'Yes, you can upgrade or downgrade your plan at any time. Changes take effect on the next billing cycle.',
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: 'Is there a free trial?',
          answer:
              'Yes, we offer a 14-day free trial for new clinics. No credit card required.',
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: 'Do you offer discounts for long-term contracts?',
          answer:
              'Yes, our annual plan includes significant savings compared to monthly billing.',
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: 'Is there support for multiple clinics?',
          answer:
              'Contact our sales team for custom Enterprise plans with multiple clinic support.',
        ),
      ],
    );
  }

  /// Build FAQ item.
  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Card(
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Get pricing plans.
  List<PricingPlan> _getPricingPlans() {
    return [
      PricingPlan(
        name: 'Basic',
        monthlyPrice: 99,
        description: 'Perfect for small clinics',
        features: [
          'Up to 5 doctors',
          'Appointment scheduling',
          'Patient records',
          'SMS notifications',
          '50 GB storage',
        ],
      ),
      PricingPlan(
        name: 'Professional',
        monthlyPrice: 299,
        description: 'Ideal for medium clinics',
        features: [
          'Up to 20 doctors',
          'All Basic features',
          'Video consultations',
          'Advanced analytics',
          'Prescription management',
          '500 GB storage',
          'Priority support',
        ],
      ),
      PricingPlan(
        name: 'Enterprise',
        monthlyPrice: 999,
        description: 'For large healthcare networks',
        features: [
          'Unlimited doctors',
          'All Professional features',
          'Multi-clinic support',
          'Custom integrations',
          'Unlimited storage',
          'Dedicated account manager',
          '24/7 Priority support',
        ],
      ),
    ];
  }

  /// Get discount percentage for billing period.
  int _getDiscount(BillingPeriod period) {
    switch (period) {
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

  /// Handle get started button press.
  void _handleGetStarted(BuildContext context, PricingPlan plan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${plan.name} plan...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Billing period enum.
enum BillingPeriod {
  monthly,
  quarterly,
  semiAnnual,
  annual;

  String get displayName {
    switch (this) {
      case BillingPeriod.monthly:
        return 'Monthly';
      case BillingPeriod.quarterly:
        return 'Quarterly (3 months)';
      case BillingPeriod.semiAnnual:
        return 'Semi-Annual (6 months)';
      case BillingPeriod.annual:
        return 'Annual (12 months)';
    }
  }
}

/// Pricing plan data model.
class PricingPlan {
  PricingPlan({
    required this.name,
    required this.monthlyPrice,
    required this.description,
    required this.features,
  });
  final String name;
  final double monthlyPrice;
  final String description;
  final List<String> features;

  /// Calculate price based on billing period.
  double getPriceForPeriod(BillingPeriod period, int discount) {
    final monthCount = _getMonthCount(period);
    return monthlyPrice * monthCount * (1 - discount / 100);
  }

  /// Get month count for billing period.
  int _getMonthCount(BillingPeriod period) {
    switch (period) {
      case BillingPeriod.monthly:
        return 1;
      case BillingPeriod.quarterly:
        return 3;
      case BillingPeriod.semiAnnual:
        return 6;
      case BillingPeriod.annual:
        return 12;
    }
  }
}
