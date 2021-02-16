class User{
  String name;
  int age;
  int maxWeight;
  String imageUrl;

  User({
    this.name,
    this.age,
    this.maxWeight,
    this.imageUrl,
});

}

User taku = User(
  name: 'Takuo Kuroki',
  age: 21,
  maxWeight: 200,
  imageUrl: 'assets/images/hoge.jpg',
);