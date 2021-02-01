enum NotesState {
  GETALL,
  INSERT,
  UPDATE,
  DELETE,
  DELETEALL,
  NOOP,
}

class Note {
  int id;
  NotesState state;
  bool editing;
  final String body;

  Note({
    this.id,
    this.state,
    this.editing = false,
    this.body,
  });

  Note copyWith({
    String body,
    NotesState state,
    int id,
    bool editing,
  }) {
    return Note(
      body: body ?? this.body,
      editing: editing ?? this.editing,
      state: state ?? this.state,
      id: id ?? this.id,
    );
  }

  Note.fromMap(Map<String, dynamic> map)
      : this.body = map['body'],
        this.editing = map['editing'],
        this.state = NotesState.values[map['state']];

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'editing': editing,
      'state': state.index,
    };
  }
}
