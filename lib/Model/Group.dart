class Group{
  final int? group_id;
  final String? group_name;

  Group({
    this.group_id,
    this.group_name,
  });

  //maping
  factory Group.fromMap(Map<String, dynamic> map){
    return Group(
      group_id: map['group_id'],
      group_name: map['group_name'],
    );
  }

  //mapping->sql
  Map<String, dynamic> toMap(){
    return {
      'group_id': group_id,
      'group_name': group_name,
    };
  }
}