import 'package:marketplace/consts/consts.dart';

Widget orderStatus({
  icon,
  color,
  title,
  showDone,
  VoidCallback? onDone
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    )
        .box
        .border(color: color)
        .roundedSM
        .padding(const EdgeInsets.all(4))
        .make(),
    trailing: SizedBox(
      height: 100,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "$title".text.color(darkFontGrey).make(),
          showDone
              ? const Icon(
                  Icons.done,
                  color: greenColor,
                )
              : Container(),
        ],
      ),
    ),
  );
}
