import Foundation

public class Developer {
    
    public var name: String?
    public weak var productManager: ProductManager?
    public weak var company: Company?
    
    
    public init() {
        name = nil
        productManager = nil
    }
    
    deinit {
        print("\(name ?? "") developer deinit")
    }
    
    public func sendMessageToCeo(){
        guard let  productManagerGuard = self.productManager else { return }
        guard let  ceoGuard = productManagerGuard.ceo else { return }
        print("Developer \(self.name ?? ""): CEO \(ceoGuard.name ?? "") - Я хочу зарплату больше" )
    }
    
    
    public func sendMessageToProductManager(){
        guard let  productManagerGuard = self.productManager else { return }
        print("Developer \(self.name ?? ""): PM \(productManagerGuard.name ?? "") - Дай ТЗ")
    }
    
}

extension Developer {
    
    public func sendMessageToDevelopersUsePM() {
        guard let productManagerGuard = self.productManager else { return }
        guard let developersGuard = productManagerGuard.developers else { return }
        for i in 0..<developersGuard.count {
            if developersGuard[i]?.name != self.name {
                print("Developer \(self.name ?? ""): Developer \(developersGuard[i]?.name ?? "") - Я отправил тебе pull-request")
            }
        }
    }
    
    public func sendMessageToDevelopersUsePM(name: String) {
        guard let productManagerGuard = self.productManager else { return }
        guard let developersGuard = productManagerGuard.developers else { return }
        for i in 0..<developersGuard.count {
            if developersGuard[i]?.name == name {
                print("Developer \(self.name ?? ""): Developer \(developersGuard[i]?.name ?? "") - Когда ты научишься писать код?")
            }
        }
    }
    
    
    public func sendMessageToDeveloper(developer: Developer?){
        if developer?.name == self.name {
            return(print("You cant write yourself"))
        }
        print("Developer \(self.name?[keyPath: \.self] ?? ""): Developer \(developer?.name ?? "") - Ты говнокодер!")
    }
    
}

