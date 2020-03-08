import Foundation

var developer1: Developer? = Developer()
var developer2: Developer? = Developer()
var productManager: ProductManager? = ProductManager()
var ceo: Ceo? = Ceo()
var company: Company? = Company()

company?.ceo = ceo
company?.productManager = productManager
company?.developers = [developer1, developer2]

ceo?.name = "Jack"
ceo?.productManager = company?.productManager

productManager?.name = "Alex"
productManager?.ceo = company?.ceo
productManager?.developers = company?.developers

developer1?.productManager = company?.productManager
developer1?.name = "Donald"
developer2?.productManager = company?.productManager
developer2?.name = "Jotaro"

ceo?.printCompany()
ceo?.printProductManager()
ceo?.printDevelopers()

company?.simulationChat()

company = nil
ceo = nil
developer2 = nil
developer1 = nil
productManager = nil

