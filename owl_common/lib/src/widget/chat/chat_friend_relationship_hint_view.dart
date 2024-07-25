import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:owl_common/owl_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatFriendRelationshipAbnormalHintView extends StatelessWidget {
  const ChatFriendRelationshipAbnormalHintView({
    super.key,
    this.blockedByFriend = false,
    this.deletedByFriend = false,
    required this.name,
    this.onTap,
  });
  final bool blockedByFriend;
  final bool deletedByFriend;
  final String name;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (blockedByFriend) {
      return StrRes.blockedByFriendHint.toText..style = Styles.ts_999999_12;
    } else if (deletedByFriend) {
      return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: RichText(
          text: TextSpan(
            text: sprintf(StrRes.deletedByFriendHint, [name]),
            style: Styles.ts_999999_12,
            children: [
              TextSpan(
                text: StrRes.sendFriendVerification,
                style: Styles.ts_999999_12,
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
