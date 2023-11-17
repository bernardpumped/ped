abstract class Diff implements Comparable<Diff> {
  final int index;
  final int size;
  const Diff(
      this.index,
      this.size,
      );

  @override
  String toString() => '${runtimeType.toString()}(index: $index, size: $size)';

  @override
  int compareTo(Diff other) => index - other.index;
}

class Insertion<E> extends Diff {
  final List<E> items;
  const Insertion(
      super.index,
      super.size,
      this.items,
      );
}

class Deletion extends Diff {
  const Deletion(
      super.index,
      super.size,
      );
}

class Modification<E> extends Diff {
  final List<E> items;
  const Modification(
      super.index,
      super.size,
      this.items,
      );

  @override
  String toString() {
    return '${runtimeType.toString()}(index: $index, size: $size, items: $items)';
  }
}
