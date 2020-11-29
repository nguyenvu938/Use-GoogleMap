//
//  MapViewController.swift
//  UseGoogleMap
//
//  Created by NguyenVu on 29/11/2020.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class MapViewController: UIViewController {
    var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var fromTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "From"
        textField.backgroundColor = .white
        return textField
    }()
    
    var toTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "To"
        textField.backgroundColor = .white
        return textField
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bookButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book", for: .normal)
        button.backgroundColor = UIColor(red: 0.26, green: 0.95, blue: 0.62, alpha: 1.00)
        button.addTarget(self, action: #selector(bookDidPress(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var locationManager: CLLocationManager = {
        var location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        location.activityType = .automotiveNavigation
        location.distanceFilter = 10
        return location
    }()
    
    var placeClient = GMSPlacesClient()
    var from: GMSPlace?
    var to: GMSPlace?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupLayout()
        setupMap()
        getCurrenLocation()
        
        let tapFromGesture = UITapGestureRecognizer(target: self, action: #selector(fromDidPress(_:)))
        let tapToGesture = UITapGestureRecognizer(target: self, action: #selector(toDidPress(_:)))
        fromTextField.addGestureRecognizer(tapFromGesture)
        toTextField.addGestureRecognizer(tapToGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(containerView)
        containerView.addSubview(fromTextField)
        containerView.addSubview(toTextField)
        containerView.addSubview(bookButton)
    }
    
    func setupLayout() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        fromTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        fromTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        fromTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        fromTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        toTextField.topAnchor.constraint(equalTo: fromTextField.bottomAnchor, constant: 20).isActive = true
        toTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        toTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        toTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bookButton.topAnchor.constraint(equalTo: toTextField.bottomAnchor, constant: 20).isActive = true
        bookButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        bookButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func openSetting() {
        let alert = UIAlertController(title: "TaxiApp", message: "TaxiApp cần truy cập vị trí của bạn để phục vụ được tốt hơn", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(settingURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingURL)
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func moveCamera(lat: Double, long: Double) {
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat, longitude: long), zoom: 15)
        mapView.animate(to: camera)
    }
    
    func setupMap() {
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 10)
        
//        do {
//            mapView.mapStyle = try GMSMapStyle(jsonString: ConfigManager.shared.googleMapStyle)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func getCurrenLocation(){
        placeClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("CurrentPlace: \(error.localizedDescription)")
            }
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.from = place;
                    self.fromTextField.text = place.formattedAddress
                }
            }
        })
    }
    
    func drawPolyline(_ polyline: String){
        if let to = to, let from = from{
            // xoá các marker trước đó đã add lên map
            mapView.clear()
            
            // thêm marker điểm đi lên map
            let pickupMarker = GMSMarker()
            pickupMarker.position = CLLocationCoordinate2D(latitude: from.coordinate.latitude, longitude: from.coordinate.longitude)
            pickupMarker.icon = UIImage(named: "lt_iconMarkerYellow")
            pickupMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            pickupMarker.title = from.formattedAddress
            pickupMarker.map = mapView
    
            // thêm marker điểm đến lên map
            let dropoffMarker = GMSMarker()
            dropoffMarker.position = CLLocationCoordinate2D(latitude: to.coordinate.latitude, longitude: to.coordinate.longitude)
            dropoffMarker.icon = UIImage(named: "lt_iconMarkerBlue")
            dropoffMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            dropoffMarker.title = to.formattedAddress
            dropoffMarker.map = mapView
    

            // Vẽ đường polyline lên trên map
            let path = GMSPath(fromEncodedPath: polyline)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = UIColor.red
            polyline.map = mapView
            
            // Focus polyline sao cho vừa màn hình của device
            let bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path!)
            mapView.animate(with: GMSCameraUpdate.fit(bounds))
        }
    }
    
    @objc func fromDidPress(_ sender: Any) {
        let searchVC = SearchViewController()
        searchVC.type = 0
        searchVC.onSelect = {[weak self] place in
            guard let strongSelf = self else { return }
            strongSelf.from = place
            strongSelf.fromTextField.text = place.formattedAddress
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func toDidPress(_ sender: Any) {
        let searchVC = SearchViewController()
        searchVC.type = 1
        searchVC.onSelect = {[weak self] place in
            guard let strongSelf = self else { return }
            strongSelf.to = place
            strongSelf.toTextField.text = place.formattedAddress
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func bookDidPress(_ sender: Any) {
        if let from = from, let to = to{
            let googleMapApiKey = "AIzaSyBPyRsfiLJQfRd8Bggv69vyW6E4mkKDUcY"
            var stringUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&mode=driving&key=\(googleMapApiKey)"
            
            stringUrl = String(format: stringUrl, "\(from.coordinate.latitude),\(from.coordinate.longitude)", "\(to.coordinate.latitude),\(to.coordinate.longitude)")
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                if let data = data{
                    let json = JSON(data)
                    let route = json["routes"][0]
                    let polyString = route["overview_polyline"]["points"].stringValue
                    
                    // sau khi gọi api, phải dispatch để lên main thread và vẽ polyline lên map
                    DispatchQueue.main.async {
                        self.drawPolyline(polyString)
                    }
                }
            })
            task.resume()
        }
    }
}

extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        //        let info = InfoWindowView.loadNib()
        //        info.addressLabel.text = marker.title
        //        return info
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 64))
        view.backgroundColor = UIColor.red
        return view
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            openSetting()
            break
        default:
            self.locationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            locationManager.stopUpdatingLocation()
            moveCamera(lat: newLocation.coordinate.latitude, long: newLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
