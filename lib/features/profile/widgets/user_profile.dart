// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

import 'package:threadnest/common/widgets/app_cached_network_image.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    super.key,
    this.dimension = 40,
  });
  final double dimension;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: const AppCachedNetworkImage(
        imageUrl: null,
        isCircular: true,
      ),
    );
  }
}
