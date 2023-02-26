//
//  DetailViewController.swift
//  PHNAssignment
//
//  Created by Admin on 23/02/23.
//

import Foundation
import UIKit

class PHNDetailViewController: UITableViewController {
    @IBOutlet weak var labelTitleForDetail: UILabel!
    @IBOutlet weak var labelDescriptionForDetail: UILabel!
    @IBOutlet weak var labelPriceForDetail: UILabel!
    @IBOutlet weak var labelNameForDetail: UILabel!
    var model: PHNModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
    }
    
    private func configureLabels() {
        
        self.title = "Details"
        
        if let unwrappedModel = model {
            labelTitleForDetail.text = unwrappedModel.title
            labelNameForDetail.text = "Catogory Name - " + unwrappedModel.name
            labelPriceForDetail.text = "Price - " + "\(unwrappedModel.price)"
            labelDescriptionForDetail.text = "Description - " + unwrappedModel.desc
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeguePageVC" {
            if let vc = segue.destination as? PHNPageViewController {
                vc.images = model?.images
            }
        }
    }
}
