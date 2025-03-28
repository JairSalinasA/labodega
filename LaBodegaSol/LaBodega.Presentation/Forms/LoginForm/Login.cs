using BCrypt.Net; 
using LaBodega.Common.Helpers;
using LaBodega.Data.Repositories;
using LaBodega.Domain.Entities;
using LaBodega.Presentation.Forms.MainForm;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms; 


namespace LaBodega.Presentation.Forms.LoginForm
{
    public partial class Login: Form
    {

        private readonly UsuarioRepository _usuarioRepository;
        public Login()
        {
            InitializeComponent();
            _usuarioRepository = new UsuarioRepository();
        }


        private void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtUser.Texts.Trim();
            string contrasena = txtContrasena.Texts.Trim();

            if (txtUser.Texts != "")
            {
                if (txtContrasena.Texts != "")
                {
                    Usuario usuario = _usuarioRepository.ObtenerUsuarioPorCredenciales(email, contrasena);

                    if (usuario != null)
                    {
                        // Muestra el formulario de bienvenida
                        bienvenidaForm bienvenida = new bienvenidaForm();
                        bienvenida.Show();
                        this.Hide(); // Oculta el formulario de inicio de sesión
                    }
                    else
                    {
                        msgError("Incorrect username or password entered. \n Please try again.");
                    }
                }
                else
                {
                    msgError("Por favor, ingrese la contraseña.");
                    return;
                }
            }
            else
            {
                msgError("Por favor, ingrese el correo.");
                return;
            }


        }

        private void msgError(string msg)
        {
            lblErrorMessage.Text = " " + msg;
            pictureErrorBox.Visible = true;
            lblErrorMessage.Visible = true;
        }

    }
}
     