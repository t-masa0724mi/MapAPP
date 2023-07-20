import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    
    @ State var place: IdentifiablePlace = IdentifiablePlace(lat: 37.334_900, long: 122.009_020)
    
    @State var address = ""
    
    var body: some View {
        VStack {
            TextField("アドレスを入れてください", text: $address)
            
            Button(action: {
                DoCoding(address: address)
            }, label: {
                Text("Search")
            })
            Map(coordinateRegion: $region,
                annotationItems: [place])
            { place in
                MapPin(coordinate: place.location,
                       tint: Color.red)
            }
        }
    }
    
    func DoCoding(address: String) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    ),
                    latitudinalMeters: 750,
                    longitudinalMeters: 750)
                
                place = IdentifiablePlace(lat: coordinate.latitude, long: coordinate.longitude)
            }
        }
    }
}

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
