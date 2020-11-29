//
//  SearchViewController.swift
//  UseGoogleMap
//
//  Created by NguyenVu on 29/11/2020.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var addressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        return textField
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var placeClient = GMSPlacesClient()
    var type = 1
    var onSelect: ((GMSPlace) -> Void)?
    var positions = [Position]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupLayout()
        
        if (type == 1){
            title = "To"
        }else{
            title = "From"
        }
        
        addressTextField.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addSubviews() {
        view.addSubview(containerView)
        containerView.addSubview(addressTextField)
        containerView.addSubview(tableView)
    }
    
    func setupLayout() {
        containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  0).isActive = true
        
        addressTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        addressTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        addressTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func getLocations(searchText: String){
        if !searchText.isEmpty{
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            filter.country = "VN"
            
            placeClient.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: nil) { (results, error) in
                
                if let results = results{
                    self.positions.removeAll()
                    for result in results{
                        let positon = Position(placeId: result.placeID, address: result.attributedPrimaryText.string, fullAddress: result.attributedFullText.string, lat: 0, long: 0)
                        self.positions.append(positon)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }else{
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        getLocations(searchText: newString)
        return true
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        let position = positions[indexPath.row]
        
        cell.textLabel?.text = position.address
        cell.detailTextLabel?.text = position.fullAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = positions[indexPath.row]
        
        placeClient.lookUpPlaceID(position.placeId) { (place, error) in
            if let place = place{
                self.onSelect?(place)
                self.navigationController?.popViewController(animated: true)
            }else{
                print(error?.localizedDescription)
            }
        }
    }
}
