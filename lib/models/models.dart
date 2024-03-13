import 'package:objectbox/objectbox.dart';

@Entity()
class Employee{
  @Id()
  int id = 0;

  String? name;
  String? dob;
  String? phone;
  String? email;
  String? expLevel;
  String? gender;
  bool? confirm;
  String? profileImageName;
  String? profileImagePath;
  String? signatureImageName;
  String? signatureImagePath;
  
  @Property(type: PropertyType.date)
  DateTime? date = DateTime.now();

  @Transient()
  int? computedProperty;

  Employee(this.name, {this.id=0, this.dob, this.phone, this.email, this.expLevel,
           this.gender, this.confirm, this.date, this.profileImageName, this.profileImagePath,
           this.signatureImageName, this.signatureImagePath});
}