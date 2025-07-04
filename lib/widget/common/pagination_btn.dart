import 'package:flutter/material.dart';
import 'btn.dart';
import '../../l10n/app_localizations.dart';

class PaginationBtn extends StatelessWidget {
  final int currentPage;
  final bool hasMoreData;
  final Function() previousPage;
  final Function() nextPage;
  const PaginationBtn({
    super.key,
    required this.currentPage,
    required this.hasMoreData,
    required this.previousPage,
    required this.nextPage,
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Btn(
            title: l10n?.prev ?? 'Prev',
            btnType: BtnType.secondary,
            enabled: currentPage > 0,
            onTap: currentPage > 0 ? previousPage : null,
          ),
          const SizedBox(width: 20),
          Text(
            '${l10n?.page ?? 'Page'} ${currentPage + 1}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 20),
          Btn(
            title: l10n?.next ?? 'Next',
            btnType: BtnType.secondary,
            enabled: hasMoreData,
            onTap: hasMoreData ? nextPage : null,
          ),
        ],
      ),
    );
  }
}
