import Foundation

public class Company {

    public weak var ceo: Ceo?
    public weak var productManager: ProductManager?
    public var developers: [Developer?]?

    public init() {
        ceo = nil
        productManager = nil
        developers = nil
    }

    deinit {
        print("Company deinit")
    }

    public init(ceo: Ceo, productManager: ProductManager, developers: [Developer?]?) {
        self.ceo = ceo
        self.productManager = productManager
        self.developers = developers
    }

    public func returnCompany() -> Company {
        guard let developersGuard = self.developers else { return Company() }
        guard let productManagerGuard = self.productManager else { return Company() }
        guard let ceoGuard = self.ceo else { return Company() }

        return Company(ceo: ceoGuard, productManager: productManagerGuard, developers: developersGuard)
    }

}

extension Company {

    public func simulationChat() {
        print("Симуляция чата")
        guard let developersGuard = self.developers else { return }
        guard let productManagerGuard = self.productManager else { return }
        guard let ceoGuard = self.ceo else { return }
        switch developersGuard.count {
        case 1:
            developersGuard[0]?.sendMessageToCeo()
            print("CEO \(ceoGuard.name ?? ""): Developer \(developersGuard[0]?.name ?? "") - Будешь работать, повышу")
            developersGuard[0]?.sendMessageToProductManager()
            print("PM \(productManagerGuard.name ?? ""): Developer \(developersGuard[0]?.name ?? "") - Скоро вышлю")
        case 2...:
            developersGuard[0]?.sendMessageToCeo()
            print("CEO \(ceoGuard.name ?? ""): Developer \(developersGuard[0]?.name ?? "") - Будешь работать, повышу")
            developersGuard[0]?.sendMessageToProductManager()
            print("PM \(productManagerGuard.name ?? ""): Developer \(developersGuard[0]?.name ?? "") - Скоро вышлю")
            developersGuard[0]?.sendMessageToDevelopersUsePM(name: developersGuard[1]?.name ?? "")
            developersGuard[1]?.sendMessageToDeveloper(developer: developersGuard[0])
        default:
            print("No developers in this company")
        }
        print("Симуляция чата окончена \n")
    }

}
