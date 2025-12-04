// category.dart

class Category {
  // Las propiedades son nulas (?) para ser opcionales y manejar datos faltantes
  int? categoryid;
  String? categoryname;
  int? status;
  int? userid;

  // Constructor Conciso
  Category({this.categoryid, this.categoryname, this.status, this.userid});

  // Factory Constructor para crear un objeto Category desde el JSON de la API
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      // ⬅️ Mapea la clave de Node.js 'category_id'
      categoryid: json['category_id'] as int?,
      // ⬅️ Mapea la clave de Node.js 'category_name'
      categoryname: json['category_name'] as String?,
      // ⬅️ Mapea la clave de Node.js 'status'
      status: json['status'] as int?,
      // ⬅️ Mapea la clave de Node.js 'user_id'
      userid: json['user_id'] as int?,
    );
  }

  // Método para convertir el objeto Category a un mapa JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // El backend de Node.js espera estas claves
    if (categoryid != null) {
      data['category_id'] = categoryid;
    }
    data['category_name'] = categoryname;
    data['status'] = status;
    data['user_id'] = userid; // ⬅️ Node.js espera 'user_id'

    return data;
  }
}
