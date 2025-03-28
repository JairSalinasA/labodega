using System;

namespace LaBodega.Domain.Entities
{
    public class Usuario
    {
        public int ID { get; set; }
        public string Nombre { get; set; }
        public string Email { get; set; }
        public string Contrasena { get; set; }
        public string Foto { get; set; } // Foto ahora es un string, no NULL
        public bool Estado { get; set; }
        public DateTime UltimoAcceso { get; set; }
        public int IntentosFallidos { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime FechaModificacion { get; set; }
        public int UsuarioCreacionID { get; set; }
        public int UsuarioModificacionID { get; set; } // Ya no es nullable
    }
}

