import Foundation

public class Ceo {
    
    public var name: String?
    public var productManager: ProductManager?
    
    public init() {
        name = nil
        productManager = nil
    }
    
    deinit {
        print("\(name ?? "") Ceo deinit")
    }
    
    public lazy var printProductManager: () -> () = { [weak self] in
        guard let  productManagerGuard = self?.productManager else {return}
        print("Product Manager:")
        print("Product Manager \(productManagerGuard.name ?? "")\n")
    }
    
    public lazy var printDevelopers: () -> () = {[weak self] in
        guard let  productManagerGuard = self?.productManager else {return}
        productManagerGuard.printDevelopers()
    }
    
    public lazy var printCompany: () -> () = {[weak self] in
        guard let  productManagerGuard = self?.productManager else {return}
        productManagerGuard.printCompany()
    }
    
}
