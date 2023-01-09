class Link {
  String? id;
  String? name;
  String? url;
  String? group;

  Link({
    this.id,
    this.name,
    this.url,
    this.group,
  });

  // Named constructor
  Link.fromJson(String _json) {}
}
