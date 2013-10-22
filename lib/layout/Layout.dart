
part of D3Dart;

typedef num ValueFunction(dynamic d);
typedef num HierarchyValueFunction(dynamic d, int depth);

class Layout {
  static PieLayout pie() {
    return new PieLayout();
  }
  static HierarchyLayout hierarchy() {
    return new HierarchyLayout();
  }
  static PartitionLayout partition() {
    return new PartitionLayout();
  }
}
