import 'package:marketplace/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool? isPass,
  Color? validatorColor,
  ValueChanged<String>? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title?.text.color(redColor).fontFamily(semibold).size(16).make() ??
          SizedBox.shrink(),
      5.heightBox,
      TextFormField(
        controller: controller,
        obscureText: isPass ?? false,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field ini harus diisi';
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: validatorColor ?? redColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: validatorColor ?? redColor,
            ),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}
