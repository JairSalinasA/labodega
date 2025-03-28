using System;
using System.Configuration;

namespace LaBodega.Common.Helpers
{
    public static class AppConfig
    {
        public static string ConnectionString
        {
            get
            {
                var connectionString = ConfigurationManager.ConnectionStrings["LaBodegaDB"];
                if (connectionString == null)
                {
                    throw new InvalidOperationException("No se encontró la cadena de conexión 'DefaultConnection' en el archivo de configuración.");
                }
                Console.WriteLine("Cadena de conexión leída: " + connectionString.ConnectionString);
                return connectionString.ConnectionString;
            }
        }
    }
}