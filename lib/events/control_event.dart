import 'dart:convert';

class ControlEvent {
  String? clientId;
  String? event;
  String? control;
  String? value;
  int? timestamp;

  ControlEvent({
    this.clientId,
    this.event,
    this.control,
    this.value,
    this.timestamp,
  });

  ControlEvent.fromJson(String _json) {
    var p = jsonDecode(_json);
    clientId = p['client_id'];
    control = p['control'];
    event = p['event'];
    value = p['value'];
    timestamp = p['timestamp'];
  }
}
