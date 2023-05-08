class ComponentDataColumnModule  {
  final String title;
  final bool? sortable;
  final String? sortKeyName;
  final bool numeric;
  final bool isDate;

  const ComponentDataColumnModule({required this.title, this.sortable, this.sortKeyName, this.numeric = false, this.isDate = false});
}