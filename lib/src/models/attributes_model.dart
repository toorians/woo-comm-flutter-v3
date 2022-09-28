// To parse this JSON data, do
//
//     final filterModel = filterModelFromJson(jsonString);

import 'dart:convert';

List<AttributesModel> filterModelFromJson(String str) => List<AttributesModel>.from(json.decode(str).map((x) => AttributesModel.fromJson(x)));

class AttributesModel {
  String id;
  String name;
  List<Term> terms;

  AttributesModel({
    required this.id,
    required this.name,
    required this.terms,
  });

  factory AttributesModel.fromJson(Map<String, dynamic> json) => AttributesModel(
    id: json["id"] == null ? '0' : json["id"],
    name: json["name"] == null ? '' : json["name"],
    terms: json["terms"] == null ? [] : List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
  );
}

class Term {
  int termId;
  String name;
  String slug;
  int termGroup;
  int termTaxonomyId;
  String taxonomy;
  String description;
  int parent;
  int count;
  String filter;
  bool selected;

  Term({
    required this.termId,
    required this.name,
    required this.slug,
    required this.termGroup,
    required this.termTaxonomyId,
    required this.taxonomy,
    required this.description,
    required this.parent,
    required this.count,
    required this.filter,
    required this.selected,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    termId: json["term_id"] == null ? 0 : json["term_id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    termGroup: json["term_group"] == null ? 0 : json["term_group"],
    termTaxonomyId: json["term_taxonomy_id"] == null ? 0 : json["term_taxonomy_id"],
    taxonomy: json["taxonomy"] == null ? '' : json["taxonomy"],
    description: json["description"] == null ? '' : json["description"],
    parent: json["parent"] == null ? 0 : json["parent"],
    count: json["count"] == null ? 0 : json["count"],
    filter: json["filter"] == null ? '' : json["filter"],
    selected: false,
  );
}
