import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final data = await getNotifications();
      setState(() {
        notifications = data;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      debugPrint('Notification error: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Failed to load notifications'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.readStatus;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isRead
            ? null
            : () async {
                final success = await readNotification(notification.id);
                if (success) {
                  // update UI / refresh list
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Unread indicator (SAFE)
              Container(
                width: 4,
                height: 48, // ✅ FIXED height
                decoration: BoxDecoration(
                  color: isRead ? Colors.transparent : Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              /// Icon
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    isRead ? Colors.grey.shade200 : Colors.blue.shade100,
                child: Icon(
                  Icons.notifications,
                  size: 18,
                  color: isRead ? Colors.grey : Colors.blue,
                ),
              ),
              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                    ),
                    if (notification.remarks != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        notification.remarks!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              if (notification.attachment != null)
                const Icon(Icons.attach_file, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
