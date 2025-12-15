import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';

class ServerStatusCard extends StatelessWidget {
  final ServerStatus serverStatus;

  const ServerStatusCard({super.key, required this.serverStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Server Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: serverStatus.allServicesRunning
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    serverStatus.allServicesRunning
                        ? 'All Systems Go'
                        : 'Issues Detected',
                    style: TextStyle(
                      fontSize: 12,
                      color: serverStatus.allServicesRunning
                          ? Colors.green[700]
                          : Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildServiceStatus(
                  'Database',
                  serverStatus.database,
                  Icons.storage,
                ),
                _buildServiceStatus('Cache', serverStatus.cache, Icons.memory),
                _buildServiceStatus(
                  'File Storage',
                  serverStatus.fileStorage,
                  Icons.folder,
                ),
                _buildServiceStatus(
                  'Email Service',
                  serverStatus.emailService,
                  Icons.email,
                ),
                _buildServiceStatus(
                  'Push Service',
                  serverStatus.pushService,
                  Icons.notifications,
                ),
                _buildServiceStatus(
                  'Analytics',
                  serverStatus.analytics,
                  Icons.analytics,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!serverStatus.allServicesRunning) ...[
              const Divider(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.read<SystemCubit>().restartServices(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Restart Services'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[700],
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatus(String name, bool isRunning, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRunning ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRunning ? Colors.green[100]! : Colors.red[100]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isRunning ? Colors.green[600] : Colors.red[600],
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isRunning ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isRunning ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 10,
                color: isRunning ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
