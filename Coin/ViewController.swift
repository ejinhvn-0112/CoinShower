//
//  ViewController.swift
//  Coin
//
//  Created by 김은중 on 2021/05/13.
//

import UIKit

// API Caller
// UI to show different cryptos
// MVVM

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self,
                           forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels = [CyproTableViewCellViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "코인 거래소"
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.getAllCryptoData { [weak self] result in
            switch result {
            case .success(let modles):
                self?.viewModels = modles.compactMap({ model in
                    // NumberFormatter
                    let price = model.price_usd ?? 0
                    let formattter = ViewController.numberFormatter
                    let priceString = formattter.string(from: NSNumber(value: price))
                    
                    let iconUrl = URL(
                        string:
                            APICaller.shared.icons.filter({ icon in
                            icon.asset_id == model.asset_id
                            }).first?.url ?? ""
                    )
                    
                  return CyproTableViewCellViewModel(
                        name: model.name ?? "N/A",
                        symobl: model.asset_id,
                        price: priceString ?? "N/A",
                        iconUrl : iconUrl
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        // Table View
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath)
            as? CryptoTableViewCell else {
                fatalError()
            }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

