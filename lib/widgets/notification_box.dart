import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lukcytravel/screen/blog_list_page.dart';

import '../screens/create_blog.dart';
import '../screens/kayıt_giris.dart';

class NotificationBox extends StatelessWidget {
  NotificationBox({Key? key, this.onTap, this.notifiedNumber = 0})
      : super(key: key);

  final GestureTapCallback? onTap;
  final int notifiedNumber;

  void handleFirstIconTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    print('İlk simgeye tıklandı');
  }

  void handleSecondIconTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogEditorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(.3)),
            ),
            child: GestureDetector(
              onTap: () => handleFirstIconTap(context),
              child: SvgPicture.asset(
                "assets/icons/person-male-svgrepo-com.svg",
                width: 25,
                height: 25,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(.3)),
            ),
            child: GestureDetector(
              onTap: () => handleSecondIconTap(context),
              child: SvgPicture.asset(
                "assets/icons/add.svg",
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
