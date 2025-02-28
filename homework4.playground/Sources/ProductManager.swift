import Foundation

public class ProductManager {

    public var name: String?
    public var developers: [Developer?]?
    public weak var ceo: Ceo?

    public init() {
        developers = nil
        ceo = nil
    }

    deinit {
        print("\(name ?? "") Product Manager deinit")
    }

}

extension ProductManager {

    public func printDevelopers() {
        guard let  developersGuard = self.developers else { return }
        print("Developers:")
        for developer in developersGuard {
            if let name = developer?.name {
                print("Developer \(name)")
            }
        }
        print("\n")
    }

    public func printCompany() {
        guard let developersGuard = self.developers else { return }
        guard let nameGuard = self.name else { return }
        guard let ceoGuard = self.ceo else { return }
        print("Состав компании:")
        for developer in developersGuard {
            if let name = developer?.name {
                print("Developer \(name)")
            }
        }
        print("CEO \(ceoGuard.name ?? "")")
        print("Producr Manager \(nameGuard) \n")
    }

}
