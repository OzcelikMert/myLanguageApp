class ComponentDataColumnModule  {
  final String title;
  final bool? sortable;
  final String? sortKeyName;
  final bool numeric;

  const ComponentDataColumnModule({required this.title, this.sortable, this.sortKeyName, this.numeric = false});
}