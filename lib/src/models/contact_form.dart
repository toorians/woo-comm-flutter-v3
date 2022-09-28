// To parse this JSON data, do
//
//     final contact7Form = contact7FormFromJson(jsonString);

import 'dart:convert';

Contact7Form contact7FormFromJson(String str) => Contact7Form.fromJson(json.decode(str));

class Contact7Form {
  Contact7Form({
    required this.id,
    required this.slug,
    required this.title,
    required this.locale,
    required this.properties,
  });

  int id;
  String slug;
  String title;
  String locale;
  Properties properties;

  factory Contact7Form.fromJson(Map<String, dynamic> json) => Contact7Form(
    id: json["id"] == null ? 0 : json["id"],
    slug: json["slug"] == null ? '' : json["slug"],
    title: json["title"] == null ? '' : json["title"],
    locale: json["locale"] == null ? '' : json["locale"],
    properties: json["properties"] == null ? Properties.fromJson({}) : Properties.fromJson(json["properties"]),
  );
}

class Properties {
  Properties({
    required this.form,
    //required this.mail,
    //required this.mail2,
    required this.messages,
    //required this.additionalSettings,
  });

  ContactForm form;
  //Mail mail;
  //Mail mail2;
  Messages messages;
  //AdditionalSettings additionalSettings;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    form: json["form"] == null ? ContactForm.fromJson({}) : ContactForm.fromJson(json["form"]),
    //mail: json["mail"] == null ? Mail.fromJson({}) : Mail.fromJson(json["mail"]),
    //mail2: json["mail_2"] == null ? Mail.fromJson({}) : Mail.fromJson(json["mail_2"]),
    messages: json["messages"] == null ? Messages.fromJson({}) : Messages.fromJson(json["messages"]),
    //additionalSettings: json["additional_settings"] == null ? AdditionalSettings.fromJson({}) : AdditionalSettings.fromJson(json["additional_settings"]),
  );
}

class AdditionalSettings {
  AdditionalSettings({
    required this.content,
    required this.settings,
  });

  String content;
  List<dynamic> settings;

  factory AdditionalSettings.fromJson(Map<String, dynamic> json) => AdditionalSettings(
    content: json["content"] == null ? '' : json["content"],
    settings: json["settings"] == null ? [] : List<dynamic>.from(json["settings"].map((x) => x)),
  );
}

class ContactForm {
  ContactForm({
    required this.content,
    required this.fields,
  });

  String content;
  List<ContactFormField> fields;

  factory ContactForm.fromJson(Map<String, dynamic> json) => ContactForm(
    content: json["content"] == null ? '' : json["content"],
    fields: json["fields"] == null ? [] : List<ContactFormField>.from(json["fields"].map((x) => ContactFormField.fromJson(x))),
  );
}

class ContactFormField {
  ContactFormField({
    required this.type,
    required this.basetype,
    required this.name,
    required this.options,
    //required this.rawValues,
    required this.labels,
    required this.values,
    //required this.pipes,
    //required this.content,
  });

  String type;
  String basetype;
  String name;
  List<String> options;
  //List<String> rawValues;
  List<String> labels;
  List<String> values;
  //List<List<String>> pipes;
  //String content;

  factory ContactFormField.fromJson(Map<String, dynamic> json) => ContactFormField(
    type: json["type"] == null ? '' : json["type"],
    basetype: json["basetype"] == null ? '' : json["basetype"],
    name: json["name"] == null ? '' : json["name"],
    options: json["options"] == null ? [] : List<String>.from(json["options"].map((x) => x)),
    //rawValues: json["raw_values"] == null ? [] : List<String>.from(json["raw_values"].map((x) => x)),
    labels: json["labels"] == null ? [] : List<String>.from(json["labels"].map((x) => x)),
    values: json["values"] == null ? [] : List<String>.from(json["values"].map((x) => x)),
    //pipes: json["pipes"] == null ? [] : List<List<String>>.from(json["pipes"].map((x) => List<String>.from(x.map((x) => x)))),
    //content: json["content"] == null ? '' : json["content"],
  );
}

class Messages {
  Messages({
    required this.mailSentOk,
    required this.mailSentNg,
    required this.validationError,
    required this.spam,
    required this.acceptTerms,
    required this.invalidRequired,
    required this.invalidTooLong,
    required this.invalidTooShort,
    required this.invalidDate,
    required this.dateTooEarly,
    required this.dateTooLate,
    required this.uploadFailed,
    required this.uploadFileTypeInvalid,
    required this.uploadFileTooLarge,
    required this.uploadFailedPhpError,
    required this.invalidNumber,
    required this.numberTooSmall,
    required this.numberTooLarge,
    required this.quizAnswerNotCorrect,
    required this.invalidEmail,
    required this.invalidUrl,
    required this.invalidTel,
    required this.captchaNotMatch,
  });

  String mailSentOk;
  String mailSentNg;
  String validationError;
  String spam;
  String acceptTerms;
  String invalidRequired;
  String invalidTooLong;
  String invalidTooShort;
  String invalidDate;
  String dateTooEarly;
  String dateTooLate;
  String uploadFailed;
  String uploadFileTypeInvalid;
  String uploadFileTooLarge;
  String uploadFailedPhpError;
  String invalidNumber;
  String numberTooSmall;
  String numberTooLarge;
  String quizAnswerNotCorrect;
  String invalidEmail;
  String invalidUrl;
  String invalidTel;
  String captchaNotMatch;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    mailSentOk: json["mail_sent_ok"] == null ? '' : json["mail_sent_ok"],
    mailSentNg: json["mail_sent_ng"] == null ? '' : json["mail_sent_ng"],
    validationError: json["validation_error"] == null ? '' : json["validation_error"],
    spam: json["spam"] == null ? '' : json["spam"],
    acceptTerms: json["accept_terms"] == null ? '' : json["accept_terms"],
    invalidRequired: json["invalid_required"] == null ? '' : json["invalid_required"],
    invalidTooLong: json["invalid_too_long"] == null ? '' : json["invalid_too_long"],
    invalidTooShort: json["invalid_too_short"] == null ? '' : json["invalid_too_short"],
    invalidDate: json["invalid_date"] == null ? '' : json["invalid_date"],
    dateTooEarly: json["date_too_early"] == null ? '' : json["date_too_early"],
    dateTooLate: json["date_too_late"] == null ? '' : json["date_too_late"],
    uploadFailed: json["upload_failed"] == null ? '' : json["upload_failed"],
    uploadFileTypeInvalid: json["upload_file_type_invalid"] == null ? '' : json["upload_file_type_invalid"],
    uploadFileTooLarge: json["upload_file_too_large"] == null ? '' : json["upload_file_too_large"],
    uploadFailedPhpError: json["upload_failed_php_error"] == null ? '' : json["upload_failed_php_error"],
    invalidNumber: json["invalid_number"] == null ? '' : json["invalid_number"],
    numberTooSmall: json["number_too_small"] == null ? '' : json["number_too_small"],
    numberTooLarge: json["number_too_large"] == null ? '' : json["number_too_large"],
    quizAnswerNotCorrect: json["quiz_answer_not_correct"] == null ? '' : json["quiz_answer_not_correct"],
    invalidEmail: json["invalid_email"] == null ? '' : json["invalid_email"],
    invalidUrl: json["invalid_url"] == null ? '' : json["invalid_url"],
    invalidTel: json["invalid_tel"] == null ? '' : json["invalid_tel"],
    captchaNotMatch: json["captcha_not_match"] == null ? '' : json["captcha_not_match"],
  );
}


Contact7FormResult contact7FormResultFromJson(String str) => Contact7FormResult.fromJson(json.decode(str));

class Contact7FormResult {
  Contact7FormResult({
    required this.into,
    required this.status,
    required this.message,
    required this.postedDataHash,
    required this.invalidFields,
  });

  String into;
  String status;
  String message;
  String postedDataHash;
  List<InvalidField> invalidFields;

  factory Contact7FormResult.fromJson(Map<String, dynamic> json) => Contact7FormResult(
    into: json["into"] == null ? '' : json["into"],
    status: json["status"] == null ? '' : json["status"],
    message: json["message"] == null ? '' : json["message"],
    postedDataHash: json["posted_data_hash"] == null ? '' : json["posted_data_hash"],
    invalidFields: json["invalid_fields"] == null ? [] : List<InvalidField>.from(json["invalid_fields"].map((x) => InvalidField.fromJson(x))),
  );
}

class InvalidField {
  InvalidField({
    required this.into,
    required this.message,
    required this.idref,
    required this.errorId,
  });

  String into;
  String message;
  dynamic idref;
  String errorId;

  factory InvalidField.fromJson(Map<String, dynamic> json) => InvalidField(
    into: json["into"] == null ? '' : json["into"],
    message: json["message"] == null ? '' : json["message"],
    idref: json["idref"],
    errorId: json["error_id"] == null ? '' : json["error_id"],
  );
}
