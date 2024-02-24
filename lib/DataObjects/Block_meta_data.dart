class BlockMetaData {
  late int app_id;
  late String url;
  late String media_type;

  BlockMetaData({
    required this.app_id,
    required this.url,
    required this.media_type,
  });

  factory BlockMetaData.fromMap(Map<String, dynamic> map) {
    return BlockMetaData(
      app_id: map["app_id"],
      url: map["url"],
      media_type: map["media_type"],
    );
  }
}
