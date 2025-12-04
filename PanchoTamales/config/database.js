const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const dbPath = path.join(__dirname, '..', 'data', 'PanchoTamales.sqlite');

// Asegura que la carpeta exista
const dir = path.dirname(dbPath);
if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
}

// Abre (y crea si no existe) la base de datos SQLite
const db = new sqlite3.Database(dbPath, sqlite3.OPEN_READWRITE | sqlite3.OPEN_CREATE, (err) => {
    if (err) {
        console.error('Error al abrir/crear la base de datos SQLite:', err);
    } else {
        console.log('Base de datos SQLite abierta/creada en:', dbPath);
    }
});

// Crea las tablas si no existen (migración simple)
db.serialize(() => {
    // 1. Tabla USERS (Clave principal: user_id)
    db.run(`
    CREATE TABLE IF NOT EXISTS users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      username TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    )
  `, (err) => {
        if (err) {
            console.error('Error creando la tabla users:', err);
        } else {
            console.log('Tabla users lista.');
        }
    });

    // 2. Tabla CATEGORIES (Clave foránea que apunta a users.user_id)
    db.run(`
    CREATE TABLE IF NOT EXISTS categories (
      category_id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_name TEXT NOT NULL,
      status BOOLEAN NOT NULL DEFAULT 1,
      user_id INTEGER,
      -- CORRECCIÓN 1: 'FOREING' debe ser 'FOREIGN'
      FOREIGN KEY(user_id) REFERENCES users(user_id)
    )
  `, (err) => {
        // CORRECCIÓN 2: Aseguramos que el error se reporte correctamente
        if (err) {
            console.error('Error creando la tabla categories:', err);
        } else {
            console.log('Tabla categories lista.');
        }
    });
});
// La llave de cierre de db.serialize() estaba incompleta, ahora está correcta.

module.exports = db;