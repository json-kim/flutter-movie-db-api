import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dart_date/dart_date.dart';

class BackupDialog extends StatelessWidget {
  final List<BackupItem> backupList;
  final void Function(BackupItem) onTap;
  final void Function(BackupItem) onDeleteTap;

  const BackupDialog({
    required this.backupList,
    required this.onTap,
    required this.onDeleteTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '백업 리스트',
            style: TextStyle(fontSize: 18.sp),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: SizedBox(
        height: 60.h,
        width: 70.w,
        child: backupList.isEmpty
            ? const Center(
                child: Text('저장된 백업 데이터가 없습니다.'),
              )
            : ListView(
                shrinkWrap: true,
                children: backupList
                    .map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.uploadDate.format('y/M/d - H:m:s')),
                        onTap: () => onTap(item),
                        trailing: IconButton(
                          onPressed: () => onDeleteTap(item),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
