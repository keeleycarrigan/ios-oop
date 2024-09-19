import Foundation

// Exercise 1
print("Exercise 1")

class Post {
    let author: String
    let content: String
    var likes: Int

    init(author: String, content: String, likes: Int) {
        self.author = author
        self.content = content
        self.likes = likes
    }

    func display() {
        let formattedPost = """
        \(content)
        By: \(author) (\(likes) likes)

        """

        print(formattedPost)
    }
}

let post1 = Post(author: "John", content: "Hello, world!", likes: 10)
let post2 = Post(author: "Keeley", content: "Do you know where the Dillbag Club is?", likes: 0)

post1.display()
post2.display()

// Exercise 2
print("\nExercise 2")

class Product {
    let name: String
    var price: Double
    var quantity: Int

    init(name: String, price: Double, quantity: Int = 0) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

final class ShoppingCartSingleton {
    static let shared = ShoppingCartSingleton()
    var products: [Product] = []

    private init() {}

    static func sharedInstance() -> ShoppingCartSingleton {
        return .shared
    }

    func addProduct(product: Product, quantity: Int)  {
        var productInCart = self.products.first(where: { $0.name == product.name })

        if (productInCart == nil) {
            product.quantity = quantity
            self.products.append(product)
        } else {
            productInCart?.quantity += quantity
        }
    }

    func removeProduct(product: Product) {
        self.products.removeAll(where: { $0.name == product.name })
    }

    func clearCart() {
        self.products.removeAll()
    }

    func getTotalPrice() -> Double {
        return self.products.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}

let milk = Product(name: "Milk", price: 3.50)
let bread = Product(name: "Bread", price: 4.00)
let cheese = Product(name: "Cheese", price: 5.00)

ShoppingCartSingleton.shared.addProduct(product: milk, quantity: 1)
ShoppingCartSingleton.shared.addProduct(product: bread, quantity: 1)
ShoppingCartSingleton.shared.addProduct(product: cheese, quantity: 3)
ShoppingCartSingleton.shared.addProduct(product: bread, quantity: 1)

print(ShoppingCartSingleton.shared.getTotalPrice())

ShoppingCartSingleton.shared.removeProduct(product: bread)

print(ShoppingCartSingleton.shared.getTotalPrice())

ShoppingCartSingleton.shared.clearCart()

print(ShoppingCartSingleton.shared.getTotalPrice())


// Exercise 3
print("\nExercise 3")

enum PaymentError: Error {
    case invalidAmount
    case insufficientFunds
}

extension PaymentError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidAmount:
            return "Invalid amount"
        case .insufficientFunds:
            return "Insufficient funds"
        }
    }
}

protocol PaymentProcessor {
    var accountBalance: Double { get }
    func processPayment(amount: Double) throws(PaymentError)
}

class CreditCardProcessor: PaymentProcessor {
    var accountBalance: Double

    init(accountBalance: Double) {
        self.accountBalance = accountBalance
    }

    func processPayment(amount: Double) throws(PaymentError) {
        if (amount < 10) {
            throw PaymentError.invalidAmount
        } else if (amount > accountBalance) {
            throw PaymentError.insufficientFunds
        } else {
            let formattedAmount = String(format: "%.2f", amount)

            print("Processing payment of $\(formattedAmount)")
        }
    }
}

class CashProcessor: PaymentProcessor {
    var accountBalance: Double

    init(accountBalance: Double) {
        self.accountBalance = accountBalance
    }

    func processPayment(amount: Double) throws(PaymentError) {
        if (amount > 5000) {
            throw PaymentError.invalidAmount
        } else if (amount > accountBalance) {
            throw PaymentError.insufficientFunds
        } else {
            let formattedAmount = String(format: "%.2f", amount)

            print("Processing payment of $\(formattedAmount)")
        }
    }
}

let ccProcessor = CreditCardProcessor(accountBalance: 1000)
let cashProcessor = CashProcessor(accountBalance: 10000)

func processPaymentType(processor: PaymentProcessor, amount: Double) {
    do {
        try processor.processPayment(amount: amount)
    } catch {
        print("Error: \(error)")
    }
}

processPaymentType(processor: ccProcessor, amount: 2000)
processPaymentType(processor: ccProcessor, amount: 500)

processPaymentType(processor: cashProcessor, amount: 6000)
processPaymentType(processor: cashProcessor, amount: 1000)

