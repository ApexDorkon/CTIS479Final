using System.ComponentModel;

namespace BLL.Models
{
    public class CartModel
    {
        public int BookId { get; set; }

        public int UserId { get; set; }

        [DisplayName("Book Name")]
        public string BookName { get; set; }

        [DisplayName("Book Price")]
        public string BookPrice { get; set; }
    }

}


