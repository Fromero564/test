using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using Test.Models;
using MySql.Data.MySqlClient;

namespace Test.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly MySqlConnection conn = new("server=localhost;uid=root;database=test");

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        /// <summary>
        /// Inserta un producto.
        /// </summary>
        [HttpPost("producto/insertar")]
        public ActionResult InsertarProducto(int idTipoProducto, string nombre, decimal precio, int cantidad)
        {
            try
            {
                conn.Open();
                string query = $"CALL sp_InsertarProducto({idTipoProducto}, '{nombre}', {precio}, {cantidad})";
                MySqlCommand command = new(query, conn);
                command.ExecuteNonQuery();
                conn.Close();
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        /// <summary>
        /// Modifica un producto.
        /// </summary>
        [HttpPost("producto/modificar")]
        public ActionResult ModificarProducto(int idProducto, int idTipoProducto, string nombre, decimal precio, int cantidad)
        {
            try
            {
                conn.Open();
                string query = $"CALL sp_ModificarProducto({idProducto}, {idTipoProducto}, '{nombre}', {precio}, {cantidad})";
                MySqlCommand command = new(query, conn);
                command.ExecuteNonQuery();
                conn.Close();
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        /// <summary>
        /// Eliminar un producto.
        /// </summary>
        [HttpPost("producto/eliminar")]
        public ActionResult EliminarProducto(int idProducto)
        {
            try
            {
                conn.Open();
                string query = $"CALL sp_EliminarProducto({idProducto})";
                MySqlCommand command = new(query, conn);
                command.ExecuteNonQuery();
                conn.Close();
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}