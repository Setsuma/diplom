enum WorkspaceType {
  noComputer('Место без компьютера'),
  withMonitor('Место с внешним монитором'),
  withOneMonitor('Место с компьютером и монитором'),
  withDualMonitor('Место с компьютером и двумя мониторами');

  final String displayName;
  const WorkspaceType(this.displayName);
}
