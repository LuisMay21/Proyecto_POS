// models/users.js

// Importa la conexión a la base de datos SQLite3.
const db = require("../config/database");
// Importa la librería bcrypt para hashear y comparar contraseñas de forma segura.
const bcrypt = require("bcrypt");

// Define la clase Users, que contendrá métodos estáticos para interactuar con la BD.
class Users {

    // Método para crear un nuevo usuario (Registro).
    // Recibe los datos del usuario y una función de callback para manejar el resultado.
    static createUser(userdata, callback) {
        // Validación inicial: Si faltan datos esenciales, devuelve un error inmediatamente.
        if (!userdata || !userdata.name || !userdata.username || !userdata.password) {
            // Usa process.nextTick para asegurar que el callback se ejecuta de forma asíncrona.
            return process.nextTick(() => callback(new Error("Campos incompletos"), null));
        }

        // Desestructura los datos del usuario para un acceso más limpio.
        const { name, username, password } = userdata;

        // 1. Hashea la contraseña:
        // El '10' es el factor de costo (cuanto más alto, más seguro, pero más lento).
        bcrypt.hash(password, 10, (err, hash) => {
            // Si hay un error al hashear, retorna el error.
            if (err) return callback(err, null);

            // Consulta SQL para insertar el nuevo usuario.
            // Los '?' son placeholders de seguridad para prevenir inyección SQL.
            const sql = "INSERT INTO users (name, username, password) VALUES (?, ?, ?)";

            // 2. Ejecuta la consulta usando db.run() (método para INSERT/UPDATE en SQLite3).
            // La función de callback debe ser 'function' para acceder a 'this'.
            db.run(sql, [name, username, hash], function (err) {
                if (err) {
                    // Si el error es de tipo SQLITE_CONSTRAINT (ej. UNIQUE), significa que el
                    // nombre de usuario ya existe.
                    if (err.code === "SQLITE_CONSTRAINT") {
                        return callback(new Error("El nombre de usuario ya existe"), null);
                    }
                    // Para otros errores de BD, retorna el error.
                    return callback(err, null);
                }

                // 3. Éxito: Devuelve un objeto con el ID recién creado (this.lastID).
                return callback(null, { id: this.lastID, name, username });
            });
        });
    }

    // Método para obtener y autenticar un usuario (Login).
    // Recibe el nombre de usuario y la contraseña en texto plano.
    static getUsers(username, password, callback) {
        // Validación inicial: Si falta el usuario o la contraseña, devuelve un error.
        if (!username || !password) {
            return process.nextTick(() => callback(new Error("Usuario o contraseña faltante"), null));
        }

        // Consulta SQL para buscar al usuario por nombre de usuario. LIMIT 1 es una optimización.
        const getUserQuery = "SELECT * FROM users WHERE username = ? LIMIT 1";

        // 1. Ejecuta la consulta usando db.get() (método para SELECT de una sola fila en SQLite3).
        db.get(getUserQuery, [username], (err, row) => {
            if (err) return callback(err, null);

            // Si 'row' es nulo, el usuario no fue encontrado.
            if (!row) return callback(null, null);

            // 2. Compara la contraseña en texto plano con el hash almacenado en 'row.password'.
            bcrypt.compare(password, row.password, (err, isMatch) => {
                if (err) return callback(err, null);

                // Si 'isMatch' es falso, la contraseña es incorrecta.
                if (!isMatch) return callback(null, null);

                // 3. Éxito: Crea una copia segura del objeto de usuario.
                const userSafe = Object.assign({}, row);
                // Elimina el hash de la contraseña de la copia antes de devolverlo al cliente.
                delete userSafe.password;

                // Devuelve el objeto de usuario sin la contraseña.
                return callback(null, userSafe);
            });
        });
    }
}   

// Exporta la clase Users para que pueda ser utilizada en las rutas de Express.
module.exports = Users;