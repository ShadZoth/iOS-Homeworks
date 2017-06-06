//
//  IconCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 10/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Social
import IconDataKit

private let reuseIdentifier = "Cell"

class IconCollectionViewController: UICollectionViewController {
    
    private var iconSet: [Icon] = IconData.iconSet
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    private var shareEnabled = false
    private var selectedIcons: [Icon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIconDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let destinationController = segue.destination as! IconDetailViewController
                destinationController.icon = iconSet[indexPaths[0].row]
                collectionView?.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showIconDetail" {
            if shareEnabled {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return iconSet.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
    
        // Configure the cell
        let icon = iconSet[indexPath.row]
        cell.iconImageView.image = UIImage(named: icon.imageName)
        cell.iconPriceLabel.text = "$\(icon.price)"
        cell.backgroundView = (icon.isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : nil
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "icon-selected"))
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            return
        }
        
        // Determine the selected items by using the indexPath
        let selectedIcon = iconSet[indexPath.row]
        
        // Add the selected item into the array
        selectedIcons.append(selectedIcon)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            return
        }
        
        let deSelectedIcon = iconSet[indexPath.row]
        
        // Find the index of the deselected icon. Here we use the index method and pass it
        // a closure. In the closure, we compare the name of the deselected icon with all
        // the items in the selected icons array. If we find a match, the index method will
        // return us the index for later removal.
        if let index = selectedIcons.index(where: { $0.name == deSelectedIcon.name }) {
            selectedIcons.remove(at: index)
        }
    }

    // MARK: - Action methods
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        
        if shareEnabled {
            
            // Post selected photos to Facebook
            if selectedIcons.count > 0 {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tweetComposer?.setInitialText("Love these icons! I am planning to purchase all of them.")
                    
                    for icon in selectedIcons {
                        tweetComposer?.add(UIImage(named: icon.imageName))
                    }
                    
                    present(tweetComposer!, animated: true, completion: nil)
                    
                }
            }
            
            // Deselect all selected items
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths  {
                    collectionView?.deselectItem(at: indexPath, animated: false)
                }
            }
            
            // Remove all items from selectedIcons array
            selectedIcons.removeAll(keepingCapacity: true)
            
            // Change the sharing mode to NO
            shareEnabled = false
            collectionView?.allowsMultipleSelection = false
            shareButton.title = "Share"
            shareButton.style = UIBarButtonItemStyle.plain
            
        } else {
            
            // Change shareEnabled to YES and change the button text to Upload
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareButton.title = "Done"
            shareButton.style = UIBarButtonItemStyle.done
        }
    }
}
