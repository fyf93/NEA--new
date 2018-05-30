import UIKit
import MapKit
import CoreLocation

struct GeoKey {
  static let latitude = "latitude"
  static let longitude = "longitude"
  static let radius = "radius"
  static let identifier = "identifier"
  static let note = "note"
  static let eventType = "eventTYpe"
    static let titolo = "tit"
    static let messaggio = "mess"
}



class Geotification: NSObject, NSCoding, MKAnnotation {  
  var coordinate: CLLocationCoordinate2D
  var radius: CLLocationDistance
  var identifier: String
  var note: String?
  var eventType: String
    var titolo: String
    var messaggio : String
  
  var title: String? {
    if (note?.isEmpty)! {
      return "No Note"
    }
    return note
  }
  
  var subtitle: String? {
    
    return "Radius: \(radius)m "
  }
  
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, title: String, message: String, eventType: String) {
    self.coordinate = coordinate
    self.radius = radius
    self.identifier = identifier
    self.titolo = title
        self.messaggio = message
    self.eventType = eventType
    
  }
  
  // MARK: NSCoding
  required init?(coder decoder: NSCoder) {
    let latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
    let longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    radius = decoder.decodeDouble(forKey: GeoKey.radius)
    identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
    note = decoder.decodeObject(forKey: GeoKey.note) as! String
    eventType = decoder.decodeObject(forKey: GeoKey.eventType) as! String
    titolo = decoder.decodeObject(forKey: GeoKey.titolo) as! String
    messaggio = decoder.decodeObject(forKey: GeoKey.messaggio) as! String
  }
  
  func encode(with coder: NSCoder) {
    coder.encode(coordinate.latitude, forKey: GeoKey.latitude)
    coder.encode(coordinate.longitude, forKey: GeoKey.longitude)
    coder.encode(radius, forKey: GeoKey.radius)
    coder.encode(identifier, forKey: GeoKey.identifier)
    coder.encode(note, forKey: GeoKey.note)
    coder.encode(eventType, forKey: GeoKey.eventType)
  }
  
}
