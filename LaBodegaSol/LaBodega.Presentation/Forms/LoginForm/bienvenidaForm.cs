using CircularProgressBar;
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
    public partial class bienvenidaForm: Form
    {
        public bienvenidaForm()
        {
            InitializeComponent();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (this.Opacity < 1) this.Opacity += 0.05;
            circularProgressBar1.Value += 1;
            circularProgressBar1.Text = circularProgressBar1.Value.ToString();
            if (circularProgressBar1.Value == 100)
            {
                timer1.Stop();
                timer2.Start();
            }
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            this.Opacity -= 0.1;
            if (this.Opacity == 0)
            {
                timer2.Stop();
                this.Close();

                // Muestra el formulario principal
                FormPrincipal main = new FormPrincipal();
                main.Show();
            }
        }

        private void bienvenidaForm_Load(object sender, EventArgs e)
        {
            //lblUsername.Text = UserCache.FirstName + ", " + UserCache.LastName;
            this.Opacity = 0.0;
            //Inicializamos estas propiedades de la barra de progreso, mediante codigo.(Opcional)
            circularProgressBar1.Value = 0;
            circularProgressBar1.Minimum = 0;
            circularProgressBar1.Maximum = 100;
            //Iniciamos el temporizador 1.
            timer1.Start();
        }
    }
}
