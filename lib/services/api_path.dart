class APIPath {
  //this is for create a job
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  //this is to read all the jobs
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}
