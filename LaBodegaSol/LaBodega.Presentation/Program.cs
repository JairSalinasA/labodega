using LaBodega.Presentation.Forms.LoginForm;
using LaBodega.Presentation.Forms.MainForm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LaBodega.Presentation
{
    static class Program
    {
        /// <summary>
        /// Punto de entrada principal para la aplicación.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new FormPrincipal());
            //Application.Run(new Login());
            Application.Run(new FormPrincipal());


        }
    }
}
