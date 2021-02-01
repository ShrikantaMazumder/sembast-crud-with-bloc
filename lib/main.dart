import 'package:flutter/material.dart';
import 'package:sembast_crud_practice/bloc/noteBloc.dart';
import 'package:sembast_crud_practice/bloc/provider.dart';
import 'package:sembast_crud_practice/database/crud.dart';
import 'package:sembast_crud_practice/models/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      builder: (context, NoteBloc bloc) => bloc ?? NoteBloc(DBLogic()),
      onDispose: (context, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Sembast Practice',
        theme: ThemeData(),
        home: DefaultTabController(
          length: 2,
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NoteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes CRUD'),
        bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.info),
              text: 'Note Page',
            ),
            Tab(
              icon: Icon(Icons.input),
              text: 'Input Form',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          InfoTab(bloc),
          FormTab(bloc),
        ],
      ),
    );
  }
}

class InfoTab extends StatefulWidget {
  final NoteBloc bloc;

  InfoTab(this.bloc);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.inSink.add(Note(state: NotesState.GETALL));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: widget.bloc.outgoing,
                builder: (context, AsyncSnapshot<List<Note>> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return ListView(
                    children: snapshot.data
                        .map(
                          (note) => GestureDetector(
                            onTap: () {
                              setState(() => widget.bloc.inSink.add(
                                    note.copyWith(
                                        editing: !note.editing,
                                        state: NotesState.UPDATE),
                                  ));
                            },
                            child: ListTile(
                              title: note.editing
                                  ? TextFormField(
                                      initialValue: note.body,
                                      onFieldSubmitted: (text) => setState(() =>
                                          widget.bloc.inSink.add(note.copyWith(
                                            body: text,
                                            editing: !note.editing,
                                            state: NotesState.UPDATE,
                                          ))),
                                    )
                                  : Text(note.body),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => setState(() =>
                                    widget.bloc.inSink.add(note.copyWith(
                                        id: note.id,
                                        state: NotesState.DELETE))),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            MaterialButton(
              onPressed: () => setState(
                () => widget.bloc.inSink.add(Note(state: NotesState.DELETEALL)),
              ),
              child: Text('Delete all'),
            )
          ],
        ),
      ),
    );
  }
}

class FormTab extends StatefulWidget {
  final NoteBloc bloc;

  FormTab(this.bloc);

  @override
  _FormTabState createState() => _FormTabState();
}

class _FormTabState extends State<FormTab> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            onFieldSubmitted: (text) {
              widget.bloc.inSink.add(
                Note(body: text, state: NotesState.INSERT),
              );
              setState(() => _controller.clear());
            },
          )
        ],
      ),
    );
  }
}
