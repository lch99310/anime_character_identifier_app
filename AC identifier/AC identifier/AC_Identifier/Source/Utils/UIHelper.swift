import UIKit

enum UIHelper {
    // MARK: - Colors
    static let primaryColor = UIColor.systemBlue
    static let secondaryColor = UIColor.systemGray6
    
    // MARK: - Button Styles
    static func styleMainButton(_ button: UIButton) {
        button.backgroundColor = primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Add shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
    }
    
    static func styleImagePreview(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = secondaryColor
        imageView.contentMode = .scaleAspectFill
        
        // Add shadow to container
        let containerView = imageView.superview!
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.1
    }
} 