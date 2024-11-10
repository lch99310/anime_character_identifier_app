import UIKit

class LoadingView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let containerView = UIView()
    
    init() {
        setupUI()
    }
    
    private func setupUI() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(activityIndicator)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func show(in view: UIView, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.containerView.removeFromSuperview()
            view.addSubview(self.containerView)
            
            NSLayoutConstraint.activate([
                self.containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                self.containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            self.messageLabel.text = message
            self.activityIndicator.startAnimating()
            self.containerView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.containerView.alpha = 1
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.alpha = 0
            }) { _ in
                self.containerView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }
        }
    }
} 