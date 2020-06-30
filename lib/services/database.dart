import 'dart:async';

import 'package:meta/meta.dart';
import 'package:timetracker/app/home/models/entry.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/services/api_path.dart';
import 'package:timetracker/services/firestore_service2.dart';

//if we need to create multiple implications for those class, then having an
// abstract class is valuable ??
abstract class Database {
//  notes
  Future<void> setJobsNote(Job job);
  Stream<List<Job>> jobsStreamNote();

  //create a job
  Future<void> setJob(Job job);
  //delete a job
  Future<void> deleteJob(Job job);
  //read all jobs
  Stream<List<Job>> jobsStream();
  //
  Stream<Job> jobStream({@required String jobId});
  //create an entry
  Future<void> setEntry(Entry entry);
  //delete an entry
  Future<void> deleteEntry(Entry entry);
  //read all entries
  Stream<List<Entry>> entriesStream({Job job});
}

//we use time as Id
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  //ensure only one object of FirestoreService is create
  final _service = FirestoreService.instance;

//  //we later replace jobData as a Job model, then add path class, then create a
//  // new method _setData to avoid repeated code.
  //step 1:
//  Future<void> createJobs(Map<String, dynamic> jobData) async {
//    final path = 'users/$uid/jobs/job_abc';
//    //Firestore.instance is a singleton object
//    final documentReference = Firestore.instance.document(path);
//    //setData returns a Future
//    await documentReference.setData(jobData);
//  }

  //step 2:
//  //we can change the following with fat arrow
//  Future<void> createJobs(Job job) async {
//    await _setData(
//      path: APIPath.job(uid, job.id),
//      data: job.toMap(),
//    );
//  }

  //step 3: refactor create job
  Future<void> setJobsNote(Job job) async => await _service.setData(
        //    final path = 'users/$uid/jobs/job_abc'
        //                 collection/documents/collection/documents

        //job.id = documentIdFromCurrentDate()
//        path: APIPath.job(uid, documentIdFromCurrentDate()),
        //we later changed this to job.id, and we assign the currentDateID when we
        // create a new job in the EditJobPage submit method, because we
        // don't to assign a new id everytime, because we want to update the job
        // title without new id
        path: APIPath.job(uid, job.id),

        data: job.toMap(),
      );

// step 4: read data:
//  //this just to show how snapshots works, and we can read the data from console;
//  void readJobs() {
//    final path = APIPath.jobs(uid);
//    final reference = Firestore.instance.collection(path);
//    final snapshots = reference.snapshots();

//    print(snapshots);

//    snapshots.listen((collectionSnapshot) {
//      //this returns a list of documents, which is a list of jobs created by this user
//      collectionSnapshot.documents
//          //documentSnapshot.data contains each job entry
//          .forEach((documentSnapshot) => print(documentSnapshot.data));
//    });

  ////print(documentSnapshot.data) shows: Flutter: {name:'marketing', ratePerHour:10}
//  }

// step 5: present data:
  //this is to show how we can make the data appear on the screen
  // we will refactor it as below:
//  Stream<List<Job>> jobsStreamNote() {
//    final path = APIPath.jobs(uid);
//    final reference = Firestore.instance.collection(path);
//    final snapshots = reference.snapshots();
//    return snapshots.map((collectionSnapshot) => collectionSnapshot.documents
//        .map((documentSnapshot) => Job.fromMap(
//                  documentSnapshot.data,
//                  documentSnapshot.documentID,
//                )
////this is previous version without factory .fromMap
////            (
////            id: documentSnapshot.data['id'],
////            name: documentSnapshot.data['name'],
////            ratePerHour: documentSnapshot.data['ratePerHour'],
////          ),
//            //always add toList() using .map
//            )
//        .toList());
//  }

//step 6: refactor read job
  Stream<List<Job>> jobsStreamNote() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
