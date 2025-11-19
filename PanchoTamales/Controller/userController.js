 // Importa el modelo de usuarios (clase Users)
const User = require('../models/users');

// ----------------------------------------------------------------------
// Función para manejar el registro de nuevos usuarios
// ----------------------------------------------------------------------
exports.registerUser = (req, res) => {
    // Desestructura los campos requeridos del cuerpo de la solicitud (JSON/formulario)
    const { name, username, password } = req.body;

    // 1. Validación de Entrada (manejo de errores del cliente)
    if (!name || !username || !password) {
        // Si falta algún campo, devuelve un error 400 Bad Request
        return res.status(400).json({ message: 'Faltan campos obligatorios' });
    }

    // Llama al método estático createUser del modelo para hashear y guardar el usuario.
    // El modelo espera un objeto { name, username, password } y un callback.
    User.createUser({ name, username, password }, (err, user) => {
        // Manejo del error de la base de datos o hashing (si err existe)
        if (err) {
            console.error('Error en createUser:', err);

            // 2. Manejo de Conflicto (Usuario Duplicado)
            // Revisa si el error es el mensaje específico del modelo O el código nativo de SQLite.
            if (err.message === 'El nombre de usuario ya existe' || (err.code && err.code === 'SQLITE_CONSTRAINT')) {
                // Si el nombre de usuario ya existe, devuelve 409 Conflict
                return res.status(409).json({ message: 'El nombre de usuario ya existe' });
            }

            // 3. Manejo de Error Interno (Otros errores, ej. BD caída, error de hashing)
            // Devuelve 500 Internal Server Error
            return res.status(500).json({ message: 'Error interno del servidor' });
        }

        // 4. Éxito: Usuario registrado correctamente
        // Devuelve 201 Created (código estándar para la creación exitosa de un recurso)
        return res.status(201).json({ message: 'Usuario registrado correctamente', user });
    });
};

// ----------------------------------------------------------------------
// Función para manejar el inicio de sesión de usuarios
// ----------------------------------------------------------------------
exports.loginUser = (req, res) => {
    // Desestructura las credenciales de la solicitud
    const { username, password } = req.body;

    // 1. Validación de Entrada
    if (!username || !password) {
        // Si falta algún campo, devuelve 400 Bad Request
        return res.status(400).json({ message: 'Faltan campos obligatorios' });
    }

    // Llama al método getUsers del modelo para buscar, obtener el hash y comparar la contraseña.
    User.getUsers(username, password, (err, user) => {
        // Manejo del error interno de la base de datos o librería
        if (err) {
            console.error('Error en getUsers (Login):', err);
            // Devuelve 500 Internal Server Error
            return res.status(500).json({ message: 'Error interno al iniciar sesión' });
        }

        // 2. Verificación de Autenticación
        // Si el modelo devuelve un objeto 'user', las credenciales son válidas.
        if (user) {
            // Login exitoso: Devuelve 200 OK y el objeto del usuario (sin el hash).
            return res.status(200).json({ message: 'Login exitoso', user });
        } else {
            // El modelo devolvió null (usuario no encontrado o contraseña incorrecta).
            // Devuelve 401 Unauthorized (Credenciales inválidas)
            return res.status(401).json({ message: 'Credenciales inválidas' });
        }
    });
};