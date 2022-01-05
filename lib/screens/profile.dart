import 'package:flutter/material.dart';
import 'package:iclone/stores/stores.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(context.watch<Store2>().name)),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (c, i) => Container(
                  color: Colors.grey,
                  child: Image.network(context.watch<Store1>().profileImage[i]),
                ),
                childCount: context.watch<Store1>().profileImage.length,
              ),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            ),
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(Icons.person),
        title: Text('팔로워 ${context.watch<Store1>().follower}명'),
        trailing: ElevatedButton(
          child: Text(context.watch<Store1>().isFollow ? 'unFollow' : 'follow'),
          onPressed: () {
            context.read<Store1>().toggleFollow();
          },
        ),
      ),
      ElevatedButton(
          onPressed: () {
            context.read<Store1>().getData();
          },
          child: Text('button'))
    ]);
  }
}
