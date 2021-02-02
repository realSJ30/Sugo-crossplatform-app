class UserProfile {
  //attributes
  String account;
  String firstname;
  String lastname;
  String middlename;
  String gender;
  String contact;
  String email;
  String idtype;
  String imgpath;
  String uid;
  double credits;
  String status;
  List<dynamic> skills;

  UserProfile(
      {this.account,
      this.firstname,
      this.lastname,
      this.middlename,
      this.gender,
      this.contact,
      this.email,
      this.idtype,
      this.imgpath,
      this.uid,
      this.credits,
      this.status,
      this.skills});
}
