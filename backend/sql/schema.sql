-- PostgreSQL schema for Supabase
-- Run this script in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS usuario (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  registro_academico VARCHAR(30) UNIQUE NOT NULL,
  nombres VARCHAR(120) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS perfiles (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario_id BIGINT UNIQUE NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  biografia TEXT,
  avatar_url TEXT,
  actualizado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS password_resets (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  token TEXT UNIQUE NOT NULL,
  expira_en TIMESTAMPTZ NOT NULL,
  consumido BOOLEAN NOT NULL DEFAULT FALSE,
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cursos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  codigo VARCHAR(20) UNIQUE NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  creditos INT NOT NULL CHECK (creditos >= 0),
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS docentes (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombres VARCHAR(120) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  email VARCHAR(150) UNIQUE,
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS curso_docente (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  curso_id BIGINT NOT NULL REFERENCES cursos(id) ON DELETE CASCADE,
  docente_id BIGINT NOT NULL REFERENCES docentes(id) ON DELETE CASCADE,
  UNIQUE (curso_id, docente_id)
);

CREATE TABLE IF NOT EXISTS publicaciones (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo_objetivo VARCHAR(10) NOT NULL CHECK (tipo_objetivo IN ('curso', 'docente')),
  curso_id BIGINT REFERENCES cursos(id) ON DELETE SET NULL,
  docente_id BIGINT REFERENCES docentes(id) ON DELETE SET NULL,
  mensaje TEXT NOT NULL,
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (tipo_objetivo = 'curso' AND curso_id IS NOT NULL) OR
    (tipo_objetivo = 'docente' AND docente_id IS NOT NULL)
  )
);

CREATE TABLE IF NOT EXISTS comentarios (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  publicacion_id BIGINT NOT NULL REFERENCES publicaciones(id) ON DELETE CASCADE,
  usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  contenido TEXT NOT NULL,
  creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cursos_aprobados (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  curso_id BIGINT NOT NULL REFERENCES cursos(id) ON DELETE CASCADE,
  fecha_aprobacion DATE,
  UNIQUE (usuario_id, curso_id)
);

CREATE INDEX IF NOT EXISTS idx_publicaciones_creado_en ON publicaciones (creado_en DESC);
CREATE INDEX IF NOT EXISTS idx_publicaciones_curso_id ON publicaciones (curso_id);
CREATE INDEX IF NOT EXISTS idx_publicaciones_docente_id ON publicaciones (docente_id);
CREATE INDEX IF NOT EXISTS idx_comentarios_publicacion_id ON comentarios (publicacion_id);
CREATE INDEX IF NOT EXISTS idx_cursos_aprobados_usuario_id ON cursos_aprobados (usuario_id);