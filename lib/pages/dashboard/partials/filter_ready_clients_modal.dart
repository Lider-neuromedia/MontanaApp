import 'package:flutter/material.dart';
import 'package:montana_mobile/providers/connection_provider.dart';
import 'package:provider/provider.dart';
import 'package:montana_mobile/providers/dashboard_provider.dart';
import 'package:montana_mobile/widgets/DropdownList.dart';
import 'package:montana_mobile/theme/theme.dart';

class FilterReadyClientsModal extends StatelessWidget {
  const FilterReadyClientsModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          const _TitleModal(title: 'Filtrar Clientes Atendidos'),
          const SizedBox(height: 30.0),
          DropdownList(
            onChanged: (dynamic value) {
              dashboardProvider.clientsReadyYear = value as String;
            },
            value: dashboardProvider.clientsReadyYear,
            items: dashboardProvider.yearsFilter
                .map<Map<String, dynamic>>((CalendarFilter discount) => {
                      'id': discount.number,
                      'value': discount.name,
                    })
                .toList(),
          ),
          const SizedBox(height: 20.0),
          DropdownList(
            onChanged: (dynamic value) {
              dashboardProvider.clientsReadyMonth = value as String;
            },
            value: dashboardProvider.clientsReadyMonth,
            items: dashboardProvider.monthsFilter
                .map<Map<String, dynamic>>(
                  (CalendarFilter discount) => {
                    'id': discount.number,
                    'value': discount.name,
                  },
                )
                .toList(),
          ),
          Expanded(child: Container()),
          _ContinueButton(
            label: 'Filtrar',
            onPressed: () {
              Navigator.pop(context);
              final connectionProvider = Provider.of<ConnectionProvider>(
                context,
                listen: false,
              );
              dashboardProvider.loadDashboardResume(
                local: connectionProvider.isNotConnected,
              );
            },
          ),
        ],
      ),
    );
  }
}

void openFilterReadyClientsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(30.0),
        topRight: const Radius.circular(30.0),
      ),
    ),
    builder: (_) {
      return FilterReadyClientsModal();
    },
  );
}

class _TitleModal extends StatelessWidget {
  const _TitleModal({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline5.copyWith(
          color: CustomTheme.textColor1,
          fontWeight: FontWeight.bold,
        );

    return Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.center,
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isBlocked = onPressed == null;

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Text(label),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          right: 10.0,
          left: 0.0,
        ),
        side: BorderSide(
          color: isBlocked ? Colors.grey : Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
    );
  }
}
