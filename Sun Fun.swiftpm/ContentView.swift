import SwiftUI
import Solar
import MapKit

struct ContentView: View {
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.655, longitude: 139.65), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State var date = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var city = " "
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("\(sunrise())")
                            .font(.title)
                        Image(systemName: "sunrise")
                            .font(.title)
                        Text("sunrise")
                    }
                    Spacer()
                    VStack {
                        Text("\(sunset())")
                            .font(.title)
                        Image(systemName: "sunset")
                            .font(.title)
                        Text("sunset")
                    }
                    Spacer()
                }
                Text(city)
                    .font(.title)
                    .padding(.top, 2)
            }
            .padding()
            .background(LinearGradient(colors: [.orange, .blue], startPoint: .leading, endPoint: .trailing))
            
            Map(coordinateRegion: $region)
                .onReceive(timer) { _ in
                    getLocation()
                }
            
            DatePicker("Date Calendar", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
    }
    
    func getLocation() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)) { placemarks, error in
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.city = city
                } else {
                    self.city = " "
                }
            }
        }
    }
    
    func sunrise() -> String {
        if let solar = Solar(for: date, coordinate: region.center) {
            if let sunriseDate = solar.sunrise {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                return formatter.string(from: sunriseDate)
            }
        }
        return ""
    }
    
    func sunset() -> String {
        if let solar = Solar(for: date, coordinate: region.center) {
            if let sunsetDate = solar.sunset {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                return formatter.string(from: sunsetDate)
            }
        }
        return ""
    }
}
