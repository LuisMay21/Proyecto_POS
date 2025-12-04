class User {
  // Las propiedades deben ser nulas si la base de datos devuelve null
  int? id;
  String? name;
  String? username;
  String? password; // Solo para pasar datos de registro, no se recibe en login

  // Constructor que inicializa las propiedades
  User({this.id, this.name, this.username, this.password});

  // Factory constructor para crear un objeto User desde el JSON de la API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Usamos 'id' si viene del JSON, si no, usamos el 'name'
      id: json['user_id'] != null ? json['user_id'] as int : null,
      name: json['name'] as String?,
      username: json['username'] as String?,
      // La contraseña no viene en el login, pero se incluye en el modelo
      password: json['password'] as String?,
    );
  }

  // Método para convertir el objeto User a JSON (útil para enviar datos al registro)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
