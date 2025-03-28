using System;
using System.Data.SqlClient;
using BCrypt.Net;
using LaBodega.Domain.Entities;
using LaBodega.Data.Helpers;
using LaBodega.Common.Helpers;

namespace LaBodega.Data.Repositories
{
    public class UsuarioRepository
    {
        private readonly DatabaseHelper _databaseHelper;

        public UsuarioRepository()
        {
            _databaseHelper = new DatabaseHelper(AppConfig.ConnectionString);
        }

        public Usuario ObtenerUsuarioPorCredenciales(string email, string contrasena)
        {
            string query = @"
    SELECT ID, Nombre, Email, Contrasena, 
           COALESCE(Foto, '') AS Foto, 
           Estado, 
           ISNULL(UltimoAcceso, GETDATE()) AS UltimoAcceso,  -- Usa ISNULL en lugar de COALESCE
           IntentosFallidos, 
           FechaCreacion, 
           FechaModificacion, 
           UsuarioCreacionID, 
           ISNULL(UsuarioModificacionID, 0) AS UsuarioModificacionID 
    FROM Usuarios 
    WHERE Email = @Email";

            using (var connection = _databaseHelper.GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Email", email);
                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string hashedPassword = reader["Contrasena"].ToString().Trim();

                            if (BCrypt.Net.BCrypt.Verify(contrasena, hashedPassword))
                            {
                                return new Usuario
                                {
                                    ID = Convert.ToInt32(reader["ID"]),
                                    Nombre = reader["Nombre"].ToString(),
                                    Email = reader["Email"].ToString(),
                                    Contrasena = hashedPassword,
                                    Foto = reader["Foto"].ToString(),
                                    Estado = Convert.ToBoolean(reader["Estado"]),
                                    UltimoAcceso = Convert.ToDateTime(reader["UltimoAcceso"]),
                                    IntentosFallidos = Convert.ToInt32(reader["IntentosFallidos"]),
                                    FechaCreacion = Convert.ToDateTime(reader["FechaCreacion"]),
                                    FechaModificacion = Convert.ToDateTime(reader["FechaModificacion"]),
                                    UsuarioCreacionID = Convert.ToInt32(reader["UsuarioCreacionID"]),
                                    UsuarioModificacionID = Convert.ToInt32(reader["UsuarioModificacionID"])
                                };
                            }
                        }
                    }
                }
            }
            return null; // Devuelve null si las credenciales son incorrectas
        }
    }
}
