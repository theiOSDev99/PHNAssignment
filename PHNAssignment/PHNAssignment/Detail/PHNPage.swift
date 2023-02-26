//
//  PHNPreviewPage.swift
//  PHNAssignment
//
//  Created by Admin on 26/02/23.
//

import Foundation
import UIKit

class PHNPage: UIViewController {
    @IBOutlet weak var detailPageImages: UIImageView!
    var imageUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAndSetImage()
    }
    
    private func downloadAndSetImage() {
        if let strUrl = imageUrlString, let url = URL(string: strUrl){
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url)
                if let theData = data {
                    DispatchQueue.main.async {
                        self.detailPageImages.image = UIImage(data: theData)
                    }
                }
            }
        }
    }
    
    
}
