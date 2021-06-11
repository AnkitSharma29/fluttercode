class Post {
  final DateTime pstDateTime;
  final String pstImage;
  final int pstStatus;
  final String pstText;
  final String usrMedId;
  final String usrMedLogo;
  final String usrMedName;

  Post({
    this.pstDateTime,
    this.pstImage,
    this.pstStatus,
    this.pstText,
    this.usrMedId,
    this.usrMedLogo,
    this.usrMedName,
  });

  factory Post.fromDocument(doc) {
    return Post(
      pstDateTime: doc['pstDateTime'],
      pstImage: doc['pstImage'],
      pstStatus: doc['pstStatus'],
      pstText: doc['pstText'],
      usrMedId: doc['usrMedId'],
      usrMedLogo: doc['usrMedLogo'],
      usrMedName: doc['usrMedName'],
    );
  }
}
