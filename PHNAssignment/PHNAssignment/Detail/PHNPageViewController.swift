//
//  PHNDetailPageViewController.swift
//  PHNAssignment
//
//  Created by Admin on 26/02/23.
//

import Foundation
import UIKit

class PHNPageViewController: UIPageViewController {
    var pages = [UIViewController]()
    var currentIndex = 0
    var images: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        configurePages()
        configurePageControl()
    }
    
    private func configurePages() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        var index = 0
        
        if let imageArr = images {
            for imageUrlString in imageArr {
                if let page = sb.instantiateViewController(withIdentifier: "AMPreviewPage" ) as? PHNPage {
                    page.imageUrlString = imageUrlString
                    pages.append(page)

                    index += 1
                }
            }
                
            if let firstPage = pages.first {
                setViewControllers([firstPage],
                                   direction: UIPageViewController.NavigationDirection.forward,
                                   animated: true,
                                   completion: nil)
            }
        }
    }
    
    private func configurePageControl() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = PHNThemeColor.themeColor
    }
}

extension PHNPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }

        if (index == 0) {
            return nil
        } else {
            currentIndex = index-1
            return pages[index-1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }

        if (index == pages.count-1) {
            return nil
        } else {
            currentIndex = index+1
            return pages[index+1]
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return currentIndex
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
            return pages.count
    }
}
