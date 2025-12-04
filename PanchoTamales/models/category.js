const db = require("../config/database");
// No necesitamos bcrypt ni use aquí
// const { use } = require("../routes/usersRoute"); 

class Category {

    /**
     * Crea una nueva categoría en la base de datos.
     * @param {object} categoryData - Datos de la categoría (category_name, user_id, status).
     * @param {function} callback - Función de callback (err, result).
     */
    static createCategory(categoryData, callback) {
        // Asegúrate de que 'status' tenga un valor por defecto si es nulo
        const { category_name, user_id, status = true } = categoryData;

        // CORRECCIÓN 1: La tabla se llama 'categories' (no 'categoria')
        // CORRECCIÓN 2: No se usan comillas simples en el nombre de la tabla ni las columnas en SQLITE
        const query = "INSERT INTO categories (category_name, status, user_id) VALUES (?, ?, ?)";

        // ADAPTACIÓN SQLITE: Usamos db.run() para INSERT
        db.run(query, [category_name, status, user_id], function (err) {
            if (err) {
                // El error de constraint SQLITE_CONSTRAINT es común aquí
                return callback(err, null);
            }
            // Devuelve el ID de la nueva categoría insertada (this.lastID en db.run)
            return callback(null, { insertId: this.lastID });
        });
    }

    /**
     * Obtiene todas las categorías asociadas a un usuario específico.
     * @param {number} UserId - ID del usuario.
     * @param {function} callback - Función de callback (err, result/rows).
     */
    static getCategories(UserId, callback) {
        // CORRECCIÓN: Los nombres de tablas y columnas son simples, sin comillas
        const query = "SELECT * FROM categories WHERE user_id = ?";

        // ADAPTACIÓN SQLITE: Usamos db.all() porque esperamos MÚLTIPLES resultados (filas)
        db.all(query, [UserId], (err, rows) => {
            if (err) {
                return callback(err, null);
            }
            // Devuelve el array de filas/categorías encontradas
            return callback(null, rows);
        });
    }

    /**
     * Actualiza una categoría existente.
     * @param {object} categoryData - Nuevos datos (category_name, status, user_id).
     * @param {number} categoryId - ID de la categoría a actualizar.
     * @param {function} callback - Función de callback (err, result).
     */
    static updateCategory(categoryData, categoryId, callback) {
        const { category_name, status, user_id } = categoryData;

        // CORRECCIÓN SQL: La sintaxis de UPDATE estaba mal (no se usa 'categories SET 'category...)
        const query = "UPDATE categories SET category_name=?, status=?, user_id=? WHERE category_id=?";

        // ADAPTACIÓN SQLITE: Usamos db.run() para UPDATE
        db.run(query, [category_name, status, user_id, categoryId], (err) => {
            if (err) {
                return callback(err, null);
            }
            // Retorna un mensaje de éxito simple o si se afectó alguna fila.
            // SQLite3 no devuelve filas afectadas fácilmente en el callback de db.run
            return callback(null, { message: "Categoría actualizada" });
        });
    }

    /**
     * Elimina una categoría por su ID.
     * @param {number} categoryId - ID de la categoría a eliminar.
     * @param {function} callback - Función de callback (err, result).
     */
    static deleteCategory(categoryId, callback) {
        // CORRECCIÓN SQL: Eliminamos las tildes/comillas raras
        const query = "DELETE FROM categories WHERE category_id = ?";

        // ADAPTACIÓN SQLITE: Usamos db.run() para DELETE
        db.run(query, [categoryId], (err) => {
            if (err) {
                return callback(err, null);
            }
            // Retorna un mensaje de éxito simple.
            return callback(null, { message: "Categoría eliminada" });
        });
    }
}

module.exports = Category;