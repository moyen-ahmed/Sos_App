class UserModel {
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? parentemail;
 // String? guardianEmail;
   String? type;
  String? profilePic;

  UserModel(
      {this.name,
        this.childEmail,
        this.id,
        this.parentemail,
        this.phone,
        // this.guardianEmail,

         this.profilePic,
         this.type
      });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'id': id,
    'childEmail': childEmail,
    'parentemail':parentemail,
    // 'guardiantEmail': guardianEmail,
    'type': type,
     'profilePic': profilePic
  };
}
