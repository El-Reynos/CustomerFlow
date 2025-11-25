# Flow API

API REST para el manejo de entries utilizando Express y Mongoose.

## 🚀 Instalación

1. Instalar dependencias:
```bash
npm install
```

2. Configurar variables de entorno:
```bash
cp .env.example .env
```

3. Editar `.env` con tu configuración de MongoDB.

## 📋 Requisitos

- Node.js (v18 o superior)
- MongoDB (local o remoto)

## 🏃 Ejecución

### Modo desarrollo:
```bash
npm run dev
```

### Modo producción:
```bash
npm start
```

## 📡 Endpoints

### GET /entries
Obtiene todas las entries.

**Respuesta exitosa (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "entry-1",
      "description": "Descripción de la entry",
      "expectedArrival": "2024-12-31T00:00:00.000Z",
      "createdBy": "usuario@example.com",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

### POST /entries
Crea una nueva entry.

**Body:**
```json
{
  "id": "entry-1",
  "description": "Descripción de la entry",
  "expectedArrival": "2024-12-31T00:00:00.000Z",
  "createdBy": "usuario@example.com"
}
```

**Respuesta exitosa (201):**
```json
{
  "success": true,
  "data": {
    "id": "entry-1",
    "description": "Descripción de la entry",
    "expectedArrival": "2024-12-31T00:00:00.000Z",
    "createdBy": "usuario@example.com",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### POST /entries/:id
Actualiza una entry existente.

**Body (campos opcionales):**
```json
{
  "description": "Nueva descripción",
  "expectedArrival": "2024-12-31T00:00:00.000Z",
  "createdBy": "nuevo@usuario.com"
}
```

**Respuesta exitosa (200):**
```json
{
  "success": true,
  "data": {
    "id": "entry-1",
    "description": "Nueva descripción",
    "expectedArrival": "2024-12-31T00:00:00.000Z",
    "createdBy": "nuevo@usuario.com",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T01:00:00.000Z"
  }
}
```

### DELETE /entries/:id
Elimina una entry.

**Respuesta exitosa (200):**
```json
{
  "success": true,
  "data": {
    "message": "Entry eliminada exitosamente"
  }
}
```

## 🏗️ Arquitectura

El proyecto sigue una arquitectura limpia con separación de responsabilidades:

```
src/
├── config/          # Configuración (base de datos, etc.)
├── controllers/     # Controladores (manejo de requests/responses)
├── middleware/      # Middlewares (error handling, logging)
├── models/          # Modelos de Mongoose
├── routes/          # Definición de rutas
├── services/        # Lógica de negocio (funciones puras)
├── app.js           # Configuración de Express
└── server.js        # Punto de entrada
```

## 🎯 Paradigma Funcional

- Funciones puras en los servicios
- Separación clara de responsabilidades
- Inmutabilidad donde sea posible
- Composición de funciones

