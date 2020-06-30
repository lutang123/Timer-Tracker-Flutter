import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timetracker/app/home/job_entries/job_entries_page.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/database.dart';

import '../models/job.dart';
import 'edit_job_page.dart';
import 'job_list_tile_original.dart';
import 'list_items_builder.dart';

class JobsPage extends StatelessWidget {
//  HomePage({@required this.auth});
////  final VoidCallback onSignOut;
//  final Auth auth;

//  Future<void> _signOut() async {
//    try {
//      await FirebaseAuth.instance.signOut();
//      onSignOut();
//    } catch (e) {
//      print(e.toString());
//    }
//  }

  //+ icon
  void _editJobPage(context) {
    EditJobPage.show(
      context,
      database: Provider.of<Database>(context, listen: false),
//      job: job,
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deleteJob(job);
      //PlatformException is from import 'package:flutter/services.dart';
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

// moved this to EditjobPage _onSubmit
//  Future<void> _createJob(BuildContext context) async {
//    try {
//      final database = Provider.of<Database>(context, listen: false);
//      await database.setJob(Job(
//        name: 'marketing',
//        ratePerHour: 30,
//        id: documentIdFromCurrentDate(),
//      ));
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Operation failed',
//        exception: e,
//      ).show(context);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _editJobPage(context),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
////        onPressed: () => _createJob(context),
//        onPressed: null,
//      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
//        add breakpoint to suspend execution, click between number and green line
//        if (snapshot.hasData) {
//         //first version
//          final jobs = snapshot.data;
//          final children = jobs.map((job) => Text(job.name)).toList();
//          return ListView(
//            children: children,
//          );

        return ListItemsBuilder<Job>(
          //ListView.separated
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );

//        }
//        if (snapshot.hasError) {
//          return Center(
//            child: Text('some error occured'),
//          );
//        }
//        return Center(
//          child: CircularProgressIndicator(),
//        );
      },
    );
  }
}
