//
//  HomeViewController.swift
//  PHNAssignment
//
//  Created by Admin on 23/02/23.
//

import Foundation
import UIKit

struct PHNModel {
    var title: String
    var price: Int
    var name: String
    var image: String
    var images: [String]
    var desc: String
}

class PHNHomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var loadingFooterView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter = PHNHomePresenter()
    private var arrHomeList: [PHNModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        presenter.delegate = self
        presenter.fetchData()
        tableViewHome.dataSource = self
        tableViewHome.delegate = self
        tableViewHome.prefetchDataSource = self
        loadingFooterView.isHidden = false
    }
}

extension PHNHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PHNHomeCell", for: indexPath) as? PHNHomeCell  {
            
            let model = arrHomeList[indexPath.row]
            cell.labelName.text = "Name - " + model.name
            cell.labelTitle.text = model.title
            cell.labelPrice.text = "Price - " + String(model.price)
            
            if let url = URL(string: model.image){
                DispatchQueue.global(qos: .background).async {
                    let data = try? Data(contentsOf: url)
                    if let theData = data {
                        DispatchQueue.main.async {
                            cell.imageHome.image = UIImage(data: theData)
                        }
                    }
                }
            }
            
        return cell
    }
        return UITableViewCell()
    }
}

extension PHNHomeViewController: PHNResponseHomePresenterProtocol {
    
    func success(homeModel: [PHNModel]) {
        arrHomeList.append(contentsOf: homeModel)
        DispatchQueue.main.async {
            self.loadingFooterView.isHidden = true
            self.tableViewHome.reloadData()
        }
    }
    
    func failure(error: PHNUILayerError) {
        var errorMessage = ""
        switch error {
        case .apiFailure:
            errorMessage = "Endpoint error"
        case .networkError:
            errorMessage = "Check your network"
        case .dataError:
            errorMessage = "Data error"
        case .unknown:
            errorMessage = "Something went wrong"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.loadingFooterView.isHidden = true
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PHNHomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrHomeList[indexPath.row]
        pushDetailViewController(model: model)
    }
    
    private func pushDetailViewController(model : PHNModel) {
        if let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "PHNDetailViewController") as? PHNDetailViewController {
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PHNHomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //print("indexPaths - \(indexPaths)")
        //Skipping pagination as API is not supporting it
    }
}
