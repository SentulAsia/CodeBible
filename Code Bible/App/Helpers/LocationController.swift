/// Copyright © 2019 Zaid M. Said
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreLocation

class LocationController: NSObject {
    static var shared = LocationController()
    
    var userLocation: CLLocation?
    
    private var locationManager: CLLocationManager
    private var timer: Timer?
    
    enum TrackingType {
        case WhenInUse, Always
    }
    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
    }
    
    func registerForLocationTracking(with type: TrackingType) {
        switch type {
        case .WhenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .Always:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startTracking(for interval: TimeInterval?) {
        locationManager.startUpdatingLocation()
        if let timeInterval = interval { scheduleStopTracking(with: timeInterval) }
    }
    
    @objc public func stopTracking() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log("Error: \(error)")
    }
}

private extension LocationController {
    func scheduleStopTracking(with interval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(stopTracking), userInfo: nil, repeats: false)
    }
}
