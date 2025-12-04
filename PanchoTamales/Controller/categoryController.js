const Category = require('../models/category');

/**
 * Crea una nueva categoría.
 * Ruta: POST /categories
 * Cuerpo: { category_name, user_id }
 */
exports.createCategory = (req, res) => {
    // 1. Extraer datos del cuerpo (req.body)
    const { category_name, user_id, status } = req.body;

    // Validación básica
    if (!category_name || !user_id) {
        return res.status(400).json({ message: 'Faltan campos obligatorios (category_name y user_id).' });
    }

    // 2. Llamar al método del modelo para crear la categoría
    Category.createCategory({ category_name, user_id, status }, (err, result) => {
        if (err) {
            console.error('Error al crear categoría:', err);
            // Manejo de error común (ej. si user_id no existe o error de BD)
            return res.status(500).json({ message: 'Error interno al registrar la categoría.', error: err.message });
        }

        // 3. Éxito: Retorna 201 Created
        return res.status(201).json({
            message: 'Categoría creada exitosamente.',
            categoryId: result.insertId
        });
    });
};

/**
 * Obtiene todas las categorías de un usuario específico.
 * Ruta: GET /categories/:userId
 */
exports.getCategories = (req, res) => {
    // 1. Extraer user_id de los parámetros de la URL (req.params)
    const userId = req.params.userId;

    if (!userId) {
        return res.status(400).json({ message: 'ID de usuario faltante en la ruta.' });
    }

    // 2. Llamar al método del modelo para obtener las categorías
    Category.getCategories(userId, (err, rows) => {
        if (err) {
            console.error('Error al obtener categorías:', err);
            return res.status(500).json({ message: 'Error interno al obtener categorías.' });
        }

        // 3. Éxito: Retorna 200 OK
        return res.status(200).json({
            message: 'Categorías recuperadas exitosamente.',
            categories: rows
        });
    });
};

/**
 * Actualiza una categoría específica.
 * Ruta: PUT /categories/:categoryId
 * Cuerpo: { category_name, status, user_id }
 */
exports.updateCategory = (req, res) => {
    // 1. Extraer ID de la categoría de la URL y datos del cuerpo
    const categoryId = req.params.categoryId;
    const { category_name, status, user_id } = req.body;

    // Validación de campos
    if (!categoryId || !category_name || user_id === undefined) {
        return res.status(400).json({ message: 'Datos incompletos para la actualización.' });
    }

    // 2. Llamar al método del modelo para actualizar
    Category.updateCategory({ category_name, status, user_id }, categoryId, (err, result) => {
        if (err) {
            console.error('Error al actualizar categoría:', err);
            return res.status(500).json({ message: 'Error interno al actualizar la categoría.', error: err.message });
        }

        // 3. Éxito: Retorna 200 OK
        return res.status(200).json({ message: 'Categoría actualizada exitosamente.' });
    });
};

/**
 * Elimina una categoría específica.
 * Ruta: DELETE /categories/:categoryId
 */
exports.deleteCategory = (req, res) => {
    // 1. Extraer ID de la categoría de la URL
    const categoryId = req.params.categoryId;

    if (!categoryId) {
        return res.status(400).json({ message: 'ID de categoría faltante en la ruta.' });
    }

    // 2. Llamar al método del modelo para eliminar
    Category.deleteCategory(categoryId, (err, result) => {
        if (err) {
            console.error('Error al eliminar categoría:', err);
            return res.status(500).json({ message: 'Error interno al eliminar la categoría.' });
        }

        // 3. Éxito: Retorna 200 OK
        return res.status(200).json({ message: 'Categoría eliminada exitosamente.' });
    });
};