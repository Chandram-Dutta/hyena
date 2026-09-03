sealed class Shape {}

final class Square extends Shape {
  Square(this.side);

  final double side;

  double area() => side * side;
}

void main() {
  print(Square(4).area());
}
