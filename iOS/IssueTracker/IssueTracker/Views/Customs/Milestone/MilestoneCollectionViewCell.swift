//
//  MilestoneCollectionViewCell.swift
//  IssueTracker
//
//  Created by 현기엽 on 2020/11/02.
//

import UIKit

@IBDesignable
class MilestoneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var title: BadgeView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var openIssues: UILabel!
    @IBOutlet weak var closeIssues: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return UIColor.init(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func config(milestone: Milestone) {
        title.text = milestone.title
        descriptionLabel.text = milestone.content
        
        guard let openCount = milestone.openCount,
            let totalCount = milestone.totalCount else {
            openIssues.isHidden = true
            closeIssues.isHidden = true
            percentageLabel.isHidden = true
            progressBar.isHidden = true
            return
        }
        let closeCount = totalCount - openCount
        openIssues.text = "\(openCount) open"
        closeIssues.text = "\(closeCount) close"
        
        var percentage = Float(closeCount) / Float(totalCount)
        if totalCount <= 0 {
            percentage = 0
        }
        progressBar.progress = percentage
        percentageLabel.text = "\(String(format: "%.1f", percentage * 100))%"
    }
    
    override func prepareForReuse() {
        openIssues.isHidden = false
        closeIssues.isHidden = false
        percentageLabel.isHidden = false
        progressBar.isHidden = false
    }
}
