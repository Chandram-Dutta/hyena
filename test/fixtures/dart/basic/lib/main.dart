class Used {
  void call() {}
}

class Dead {
  void call() {}
}

void main() {
  Used().call();
}
