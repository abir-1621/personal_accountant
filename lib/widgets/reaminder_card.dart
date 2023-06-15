import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import '../screens/reminder_page.dart';
import '../utils/helpers.dart';
import 'my_card.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard(this.reminder);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      onTap: () {  },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reminder.title} (${reminder.type.toString().split('.').last ?? ''})',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                if (reminder.description != null) ...[
                  SizedBox(height: 6.0),
                  Text(
                    reminder.description!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 16, height: 1.2),
                  ),
                ],
                if (reminder.dateTime != null) ...[
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Hero(
                        tag: reminder.key,
                        child: Material(
                          color: Colors.transparent,
                          child: Chip(
                            backgroundColor:
                            Theme.of(context).colorScheme.primary,
                            label: Text(
                              getFormattedDate(reminder.dateTime!),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Chip(
                        backgroundColor:
                        Theme.of(context).colorScheme.tertiary,
                        label: Text(
                          'weekly',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: ElevatedButton(
              onPressed: () {
                toPage(
                  context,
                  ReminderPage(isEdit: true, reminder: reminder),
                );
              },
              child: Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }
}
