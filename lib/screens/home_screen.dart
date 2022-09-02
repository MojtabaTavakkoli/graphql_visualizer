import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_visualizer/Helper/graphql_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var result = 'so far nothing !';
  final sampleQuery = r'''
            query Users {
              users {
                id
                username
                displayName
                projects {
                  id
                  title
                }
                projectsAggregate {
                  count
                }
                projectsConnection {
                  totalCount
                }
              }
            }
      ''';

  late TextEditingController requestTextEditingController;

  @override
  void initState() {
    super.initState();
    requestTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey.withAlpha(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDivider(),
                const Text('See the Result here :'),
                _buildDivider(),
                Expanded(
                  child: Text(result),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Welcome to Neo4j client prototype app !'),
                _buildDivider(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      requestTextEditingController.text = sampleQuery;
                      setState(() {});
                    },
                    child: const Text('Load a sample query'),
                  ),
                ),
                _buildDivider(height: 20.0),
                const Text('Enter Request :'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                  ),
                  child: TextField(
                    controller: requestTextEditingController,
                    maxLines: null,
                  ),
                ),
                _buildDivider(height: 20.0),
                ElevatedButton(
                  onPressed: () => _sendRequest(),
                  child: const Text('Send Request'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildDivider({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  void _sendRequest() async {
    result = 'request sent !';
    setState(() {});

    final GraphQLClient client = GraphQLHelper.getClient();

    final QueryOptions options = QueryOptions(
      document: gql(requestTextEditingController.text),
      variables: const {},
    );

    final QueryResult queryResult = await client.query(options);

    if (queryResult.hasException) {
      result = queryResult.exception.toString();
      setState(() {});
      return;
    }

    result = queryResult.data!.toString();
    setState(() {});
  }
}
