using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows; // Necesario para manejar recursos de aplicación
using System.Windows.Media; // Para colores y brushes

namespace LaBodega.Presentation.Helpers
{
    public static class ThemeHelper
    {
        private const string LightThemeName = "Light";
        private const string DarkThemeName = "Dark";

        private static ResourceDictionary GetThemeDictionary(string themeName)
        {
            // Crea un nuevo ResourceDictionary para el tema solicitado
            var dict = new ResourceDictionary();

            switch (themeName)
            {
                case LightThemeName:
                    // Define recursos para el tema claro
                    dict["BackgroundColor"] = Brushes.White;
                    dict["ForegroundColor"] = Brushes.Black;
                    dict["PrimaryColor"] = Brushes.DodgerBlue;
                    dict["SecondaryColor"] = Brushes.LightGray;
                    dict["TextBrush"] = Brushes.Black;
                    dict["BorderBrush"] = Brushes.DarkGray;
                    break;

                case DarkThemeName:
                    // Define recursos para el tema oscuro
                    dict["BackgroundColor"] = new SolidColorBrush(Color.FromRgb(30, 30, 30));
                    dict["ForegroundColor"] = Brushes.White;
                    dict["PrimaryColor"] = Brushes.DarkBlue;
                    dict["SecondaryColor"] = new SolidColorBrush(Color.FromRgb(60, 60, 60));
                    dict["TextBrush"] = Brushes.White;
                    dict["BorderBrush"] = Brushes.Gray;
                    break;
            }

            return dict;
        }

        public static void ApplyTheme(bool isDarkTheme)
        {
            var themeName = isDarkTheme ? DarkThemeName : LightThemeName;
            var themeDict = GetThemeDictionary(themeName);

            // Limpia los recursos antiguos del mismo tema (si existen)
            var oldDict = Application.Current.Resources.MergedDictionaries
                .FirstOrDefault(d => d.Contains("ThemeName") && (string)d["ThemeName"] == themeName);

            if (oldDict != null)
            {
                Application.Current.Resources.MergedDictionaries.Remove(oldDict);
            }

            // Añade el nombre del tema al diccionario para identificarlo luego
            themeDict["ThemeName"] = themeName;

            // Aplica el nuevo tema
            Application.Current.Resources.MergedDictionaries.Add(themeDict);
        }

        public static bool IsDarkThemeApplied()
        {
            bool currentTheme = ThemeHelper.IsDarkThemeApplied();
             ThemeHelper.ApplyTheme(!currentTheme);

            return currentTheme;
        }
    }
}