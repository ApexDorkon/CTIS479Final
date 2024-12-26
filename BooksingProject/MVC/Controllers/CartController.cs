using BLL.Controllers.Bases;
using BLL.DAL;
using BLL.Models;
using BLL.Services.Bases;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MVC.Controllers
{
    [Authorize] // Require authentication
    public class CartController : MvcController
    {
        const string SESSIONKEY = "Cart";

        private readonly HttpServiceBase _httpService;
        private readonly IService<Book, BookModel> _bookService;

        public CartController(HttpServiceBase httpService, IService<Book, BookModel> bookService)
        {
            _httpService = httpService;
            _bookService = bookService;
        }

        private int GetUserId() => Convert.ToInt32(User.Claims.SingleOrDefault(c => c.Type == "Id")?.Value);

        private List<CartModel> GetSession(int userId)
        {
            // Retrieve the session cart and filter by user
            var cart = _httpService.GetSession<List<CartModel>>(SESSIONKEY);
            return cart?.Where(f => f.UserId == userId).ToList() ?? new List<CartModel>();
        }

        public IActionResult Get()
        {
            // Get cart for the current user
            var cart = GetSession(GetUserId());
            return View("List", cart);
        }

        public IActionResult Remove(int bookId)
        {
            var cart = GetSession(GetUserId());
            var cartItem = cart.FirstOrDefault(c => c.BookId == bookId);

            if (cartItem != null) // Check if the item exists
            {
                cart.Remove(cartItem);
                _httpService.SetSession(SESSIONKEY, cart);
                TempData["Message"] = "Item removed from your cart.";
            }
            else
            {
                TempData["Message"] = "Item not found in your cart.";
            }

            return RedirectToAction(nameof(Get));
        }

        public IActionResult Add(int bookId)
        {
            int userId = GetUserId();
            var cart = GetSession(userId);

            // Check if the item is already in the cart
            if (!cart.Any(f => f.BookId == bookId))
            {
                var book = _bookService.Query().SingleOrDefault(b => b.Record.Id == bookId);
                if (book == null)
                {
                    TempData["Message"] = "Book not found.";
                    return RedirectToAction("Index", "Books");
                }

                var cartItem = new CartModel()
                {
                    BookId = bookId,
                    UserId = userId,
                    BookName = book.Name,
                    BookPrice = book.Price
                };

                cart.Add(cartItem);
                _httpService.SetSession(SESSIONKEY, cart);
                TempData["Message"] = $"\"{book.Name}\" added to cart.";
            }
            else
            {
                TempData["Message"] = "This book is already in your cart.";
            }

            return RedirectToAction("Index", "Books");
        }
    }
}
