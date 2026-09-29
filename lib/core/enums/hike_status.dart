enum HikeStatus {
  notStarted('Sin iniciar'),
  inProgress('En curso'),
  paused('En pausa'),
  finished('Finalizada');

  const HikeStatus(this.label);
  final String label;
}
