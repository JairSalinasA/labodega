using FontAwesome.Sharp;
using LaBodega.Presentation.Helpers;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LaBodega.Presentation.Forms.MainForm
{
    public partial class FormPrincipal : Form
    {
        public FormPrincipal()
        {
            InitializeComponent();
            panelMenu.Width = 250; // Establece un valor inicial 
            this.FormClosing += FormPrincipal_FormClosing;
        }
        private void FormPrincipal_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit(); // Cierra toda la aplicación, incluyendo formularios ocultos
        }

        private void iconButton5_Click(object sender, EventArgs e)
        {
            if (this.panelMenu.Width>200)
            {
                panelMenu.Width=150;
                btnMenu.Dock = DockStyle.Left;
                foreach (Button btnMenu in panelMenu.Controls.OfType<Button>())
                {
                    btnMenu.Font = new Font(btnMenu.Font.FontFamily, 7, btnMenu.Font.Style);
                    btnMenu.ImageAlign = ContentAlignment.MiddleCenter;
                    btnMenu.Padding =new Padding(0);
                    btnMenu.TextImageRelation = TextImageRelation.ImageAboveText;
                    btnMenu.TextAlign = ContentAlignment.MiddleCenter; 
                }
            }
            else  
            {
                panelMenu.Width=250;
                btnMenu.Dock = DockStyle.Left;
                foreach (Button btnMenu in panelMenu.Controls.OfType<Button>())
                {
                    btnMenu.Text=btnMenu.Tag.ToString();
                    btnMenu.TextAlign = ContentAlignment.MiddleCenter;  
                    btnMenu.TextImageRelation=TextImageRelation.ImageBeforeText;
                    btnMenu.ImageAlign = ContentAlignment.MiddleLeft;
                    btnMenu.Padding =new Padding(10);
                    btnMenu.Margin = new Padding(3);

                }
            }
        }
  
        private void iconButton7_Click(object sender, EventArgs e)
        {
            string[] items = {
                 "💰 Cotizaciones",
                 "🧾 Ventas",
                 "📊 Análisis de productos",
                 "🕰️ Historial",
                 "👥 Clientes"
            };

            ShowCustomMenu(iconButton7, items);
        }

        private void iconButton8_Click(object sender, EventArgs e)
        {
            string[] items = {
                "📋 Órdenes de compra",
                "📦 Adquisiciones",
                "🤝 Proveedores",
                "🔄 Conciliaciónes"
            };

            ShowCustomMenu(iconButton8, items);
        }

        private void iconButton9_Click(object sender, EventArgs e)
        {
            string[] items = {
                 "📌 Stock",
                 "↔️ Movimientos",
                 "📑 Reportes",
                 "💲 Existencias"
            };

            ShowCustomMenu(iconButton9, items);
        }

        private void iconButton10_Click_1(object sender, EventArgs e)
        {
            string[] items = {
                "➡️ Cuentas por cobrar",
                "⬅️ Cuentas por pagar",
                "🏦 Arqueo de caja",
                "📉 Estados financieros",
                "💰 Gastos y costos"
            };

            ShowCustomMenu(iconButton10, items);
        }

        private void iconButton11_Click(object sender, EventArgs e)
        {
            string[] items = {
                "📊 Dashboard ejecutivo",
                "📈 Reportes gerenciales",
                "🔔 Alertas y notificaciones",
                "📌 Indicadores clave"
            };

            ShowCustomMenu(iconButton11, items);
        }

        private void iconButton12_Click(object sender, EventArgs e)
        {
            string[] items = {
                "⚙️ Parámetros generales",
                "🔐 Seguridad y usuarios",
                "🎨 Personalización",
                "💾 Copias de seguridad"
             };

            ShowCustomMenu(iconButton12, items);
        }

        private void ShowCustomMenu(IconButton button, string[] items)
        {
            ContextMenuStrip menu = new ContextMenuStrip();

            // Basic menu configuration
            menu.BackColor = button.BackColor;
            menu.ForeColor = button.ForeColor;
            menu.Font = button.Font;
            menu.ShowImageMargin = false;
            menu.ShowCheckMargin = false;
            menu.Padding = new Padding(1);
            menu.Margin = new Padding(0);

            // Calculate width with a more robust method
            using (Graphics g = menu.CreateGraphics())
            {
                // Minimum width setting (adjust as needed)
                int minWidth = Math.Max(200, button.Width);

                // Calculate maximum text width
                int maxTextWidth = items.Max(item =>
                    (int)g.MeasureString(item, menu.Font).Width);

                // Final width calculation
                int menuWidth = Math.Max(minWidth, maxTextWidth + 40);

                menu.Width = menuWidth;

                // Create menu items with consistent sizing
                foreach (var item in items)
                {
                    var menuItem = new ToolStripMenuItem(item)
                    {
                        AutoSize = false,
                        Width = menuWidth,
                        Height = 30,  // Fixed height
                        Padding = new Padding(10, 4, 10, 4),
                        Margin = new Padding(0),
                        TextAlign = ContentAlignment.MiddleLeft
                    };

                    menu.Items.Add(menuItem);
                }
            }

            // Show menu aligned with button
            menu.Show(button, new Point(button.Width, 0));
        }

        private void iconButton6_Click(object sender, EventArgs e)
        {

        }        

        private void rjToggleButton1_CheckedChanged(object sender, EventArgs e)
        {
            bool temaOscuro = rjToggleButton1.Checked;

            // Guardar la preferencia en Settings
            Properties.Settings.Default.TemaOscuro = temaOscuro;
            Properties.Settings.Default.Save(); // Guarda la configuración para futuras ejecuciones

            AplicarTema(temaOscuro);
        }

        private void AplicarTema(bool oscuro)
        {
            if (oscuro)
            {
                panel2.BackColor = Color.FromArgb(10, 10, 10);
                panelMenu.BackColor = Color.FromArgb(10, 10, 10);
                pictureBox1.BackColor = Color.FromArgb(10, 10, 10);
                tableLayoutPanel1.BackColor = Color.FromArgb(10, 10, 10);
                iconButton6.BackColor = Color.FromArgb(10, 10, 10);
                iconButton7.BackColor = Color.FromArgb(10, 10, 10);
                iconButton8.BackColor = Color.FromArgb(10, 10, 10);
                iconButton9.BackColor = Color.FromArgb(10, 10, 10);
                iconButton10.BackColor = Color.FromArgb(10, 10, 10);
                iconButton11.BackColor = Color.FromArgb(10, 10, 10);
                iconButton12.BackColor = Color.FromArgb(10, 10, 10);
                pictureBox1.Image = Properties.Resources.noche;
            }
            else
            {
                panel2.BackColor = Color.White;
                panelMenu.BackColor = Color.White;
                pictureBox1.BackColor = Color.White;
                tableLayoutPanel1.BackColor = Color.White;
                iconButton6.BackColor = Color.White;
                iconButton7.BackColor = Color.White;
                iconButton8.BackColor = Color.White;
                iconButton9.BackColor = Color.White;
                iconButton10.BackColor = Color.White;
                iconButton11.BackColor = Color.White;
                iconButton12.BackColor = Color.White;
                pictureBox1.Image = Properties.Resources.dia;
            }
        }

        private void FormPrincipal_Load(object sender, EventArgs e)
        {
            bool temaOscuro = Properties.Settings.Default.TemaOscuro;
            rjToggleButton1.Checked = temaOscuro; // Sincronizar con el ToggleButton
            AplicarTema(temaOscuro); // Aplicar el tema al cargar
        }
    }
}
