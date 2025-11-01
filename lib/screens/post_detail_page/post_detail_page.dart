import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';

import '../../models/body/post/listing_item_model.dart' show ListingItem;

class PostDetailPage extends StatefulWidget {
  final ListingItem item;

  const PostDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int currentImageIndex = 0;
  bool isLiked = false;
  bool descriptionExpanded = false;
  late PageController imageController;
  @override
  void initState() {
    super.initState();
    imageController = PageController();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 400,
                      color: Colors.grey[200],
                      child: PageView.builder(
                        controller: imageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentImageIndex = index;
                          });
                        },
                        itemCount: widget.item.images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.item.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: AppDimens.getTop(context),
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: isLiked ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.share_outlined, size: 20, color: Colors.black),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.more_vert, size: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${currentImageIndex + 1}/${widget.item.images.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (currentImageIndex > 0)
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              imageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white.withOpacity(0.6),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    if (currentImageIndex < widget.item.images.length - 1)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              imageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white.withOpacity(0.6),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.categories.isNotEmpty
                            ? widget.item.categories.join(' / ')
                            : 'Danh mục',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.item.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '${widget.item.price} đ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
                          ),
                          SizedBox(width: 8),
                          Text('Lưu', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.item.address,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.my_location, size: 16, color: Colors.blue),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            'Cập nhật 4 giờ trước',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange[200],
                        ),
                        child: Center(
                          child: Text(
                            'T',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thanh',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Phần hội: 76%',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '2002 Đã bán',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Hoạt động 4 giờ trước',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Icon(Icons.add, size: 18, color: Colors.grey[600]),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Icon(Icons.star_border, size: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        'Chat nhanh:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Bạn có ship gà không?',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Gà này còn không?',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mô tả chi tiết',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.item.description,
                        maxLines: descriptionExpanded ? null : 3,
                        overflow: descriptionExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            descriptionExpanded = !descriptionExpanded;
                          });
                        },
                        child: Text(
                          descriptionExpanded ? 'Thu gọn' : 'Xem thêm',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle_outlined, size: 18, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            'SDT liên hệ: 034251***',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          Spacer(),
                          Text(
                            'Gọi ngay',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: AppDimens.getBottom(context), top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColor.cGray70)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.sms, color: Colors.grey[600], size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Chat với người bán')));
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Gọi điện cho người bán',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DemoItemDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListingItem mockItem = ListingItem(
      id: 1,
      userId: 123,
      title: 'Bầy chợi rắc gắn 2 thắng',
      description:
          'Bán sỉ bầy chọi rắc hơn trăm con loại 3, 4. Slang ...zá sỉ 75k...lẻ 100k...có gà tốt. Gà hoại ...trông mái để...',
      price: '75.000',
      address: 'Phường An Phú, Thành phố Thuận An, Bình Dương',
      status: 'active',
      expiredAt: DateTime.now().add(Duration(days: 30)),
      isPinned: 0,
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
      updatedAt: DateTime.now().subtract(Duration(hours: 4)),
      wardCode: 'ward123',
      provinceCode: 'province123',
      images: [
        'https://via.placeholder.com/600x600?text=Image+1',
        'https://via.placeholder.com/600x600?text=Image+2',
        'https://via.placeholder.com/600x600?text=Image+3',
      ],
      categories: ['Gà Nòi (gà Chọi)', 'Gà lớn (từ 3 tháng tuổi)'],
    );

    return MaterialApp(home: PostDetailPage(item: mockItem));
  }
}
