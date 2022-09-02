import 'package:graphql/client.dart';

class GraphQLHelper {
  static GraphQLClient getClient() {
    final Link link = HttpLink(
      'http://localhost:4000/',
      defaultHeaders: {},
    );

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}
