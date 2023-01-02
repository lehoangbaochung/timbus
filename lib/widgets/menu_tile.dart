import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? leading;
  final IconData? trailing;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const MenuTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      title: title == null ? null : Text(title!),
      subtitle: subtitle == null ? null : Text(subtitle!),
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(leading),
      ),
      trailing: SizedBox(
        height: double.infinity,
        child: Icon(trailing), 
      ),
    );
  }
}
