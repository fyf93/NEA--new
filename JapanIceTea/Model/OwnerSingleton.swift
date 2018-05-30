
import UIKit
import CloudKit
//ci sono i riferimenti a tutte le informazioni relative al proprietario connesso (elenco locali, elenco annunci, etc)
class OwnerSingleton{
    static var email = String()
    static var ID = String()
    static var password = String()
    static var piva = String()
    static var premium = String()
    static var refOwner : CKReference?

    static var businessLocals = [BusinessLocal]()
    static var advertisements = [Advertisement]()
    static var idxBusinessLocalSelected = -1
    static var idxAdvertisementSelected = -1
}
