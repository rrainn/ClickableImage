//
//  ClickableImage
//  Copyright © 2018 rrainn, Inc. All rights reserved.
//  Licensed under the MIT license
//

import UIKit
extension UIImageView {
	
	private class _CFTapGestureRecognizer : UITapGestureRecognizer { }
	private var _imageTap: _CFTapGestureRecognizer? { return self.gestureRecognizers?.first(where: { $0 is _CFTapGestureRecognizer }) as? _CFTapGestureRecognizer }
	
	public var isClickableExpandEnabled: Bool {
		return _imageTap != nil
	}

	public func enableClickableExpand() {
		if _imageTap == nil {
			let imageTapExpand = _CFTapGestureRecognizer(target: self, action: #selector(imageTapped))
			self.addGestureRecognizer(imageTapExpand)
			self.isUserInteractionEnabled = true
		}
	}
	public func disableClickableExpand() {
		if let theImageTap = _imageTap {
			self.removeGestureRecognizer(theImageTap)
		}
	}
	public func toggleClickableExpand() {
		_imageTap == nil ? enableClickableExpand() : disableClickableExpand()
	}

	@objc private func imageTapped(_ sender: UITapGestureRecognizer) {
		let imageView = sender.view as! UIImageView
		let expandableImageView = ExpandableImageView.init(frame: UIScreen.main.bounds, image: imageView.image!)
		
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			
			// topController should now be your topmost view controller
			topController.view.addSubview(expandableImageView)
		}
	}
	
}

fileprivate class ExpandableImageView: UIView, UIScrollViewDelegate {
	var newImageView: UIImageView = UIImageView()
	var panCoord: CGPoint = CGPoint.zero
	
	var originalCoord: CGPoint = CGPoint.zero
	
	var scrollableView: UIScrollView = UIScrollView()
	
	init(frame: CGRect, image: UIImage) {
		super.init(frame: frame)
		self.backgroundColor = .black
		
		newImageView = UIImageView(image: image)
		newImageView.frame = UIScreen.main.bounds
		newImageView.backgroundColor = .black
		newImageView.contentMode = .scaleAspectFit
		
		scrollableView = UIScrollView.init(frame: UIScreen.main.bounds)
		scrollableView.delegate = self
		scrollableView.minimumZoomScale = 0.5
		scrollableView.maximumZoomScale = 5.0
		scrollableView.contentSize = newImageView.bounds.size
		scrollableView.autoresizingMask = .flexibleWidth
		scrollableView.addSubview(newImageView)
		
		self.addSubview(scrollableView)
		self.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
		self.addGestureRecognizer(tap)
		
		let drag = UIPanGestureRecognizer(target: self, action: #selector(dragged))
		self.addGestureRecognizer(drag)
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return newImageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let imageViewSize = newImageView.frame.size
		let scrollViewSize = scrollView.bounds.size
		
		let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
		let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
		
		scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
	}
	
	@objc func dragged(_ sender: UIPanGestureRecognizer) {
		if(sender.state == .began) {
			self.panCoord = sender.location(in: scrollableView)
			self.originalCoord = sender.location(in: self)
		}
		
		let newCoord: CGPoint = sender.location(in: scrollableView)
		let newCoordSuperView: CGPoint = sender.location(in: self)
		
		if (sender.state == .ended) {
			let decelerationRate = UIScrollView.DecelerationRate.normal
			let originalVelocity = sender.velocity(in: self)
			let velocity = abs(originalVelocity.x) + abs(originalVelocity.y)
			let lastCoord = sender.location(in: self)
			
			// Get calculated position
			let projectedPosition: CGPoint = CGPoint(
				x: CGFloat(Float(lastCoord.x) + project(initialVelocity: Float(originalVelocity.x), decelerationRate: Float(decelerationRate.rawValue))),
				y: CGFloat(Float(lastCoord.y) + project(initialVelocity: Float(originalVelocity.y), decelerationRate: Float(decelerationRate.rawValue)))
			)
			
			if (projectedPosition.offScreen()) {
				let change = (projectedPosition.y - newCoordSuperView.y) / (projectedPosition.x - newCoordSuperView.x)
				
				var newPoint: CGPoint = CGPoint(x: projectedPosition.x, y: projectedPosition.y)
				repeat {
					newPoint.x += 1
					newPoint.y += change
				} while !newPoint.offScreen()
				newPoint.x -= 1
				newPoint.y -= change
				
				let speed: CGFloat = 1500 // higher number = slower duration
				let duration: TimeInterval = TimeInterval((1 / velocity) * speed)
				
				self.newImageView.backgroundColor = .clear
				UIView.animate(withDuration: duration, animations: {
					self.scrollableView.center = newPoint
					self.backgroundColor = .clear
				}) { _ in
					self.removeFromSuperview()
				}
				return
			} else {
				UIView.animate(withDuration: 1.0, animations: {
					self.scrollableView.center = self.center
				})
			}
		}
		
		let dX = newCoord.x - panCoord.x
		let dY = newCoord.y - panCoord.y
		
		scrollableView.frame = CGRect(x: (scrollableView.frame.origin.x)+dX, y: (scrollableView.frame.origin.y)+dY, width: (scrollableView.frame.size.width), height: (scrollableView.frame.size.height))
	}
	
	// https://developer.apple.com/videos/play/wwdc2018/803/
	// 00:46:17
	func project(initialVelocity: Float, decelerationRate: Float) -> Float {
		return (initialVelocity / 1000.0) * decelerationRate / (1.0 - decelerationRate)
	}
	
	func distanceBetween(_ a: CGPoint, _ b: CGPoint) -> Float {
		return Float((pow((a.x - a.y), 2) + pow((b.x - b.y), 2)).squareRoot())
	}
	
	@objc fileprivate func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
		sender.view?.removeFromSuperview()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func distanceBetweenPoints(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
		return CGFloat(hypotf(Float(p1.x-p2.x), Float(p1.y-p2.y)))
	}
}

fileprivate extension CGPoint {
	func offScreen() -> Bool {
		return self.x > UIScreen.main.bounds.width || self.x < 0 || self.y > UIScreen.main.bounds.height || self.y < 0
	}
}

