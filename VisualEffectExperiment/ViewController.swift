//
//  ViewController.swift
//  VisualEffectExperiment
//
//  Created by Adrian Bolinger on 3/17/18.
//  Copyright © 2018 Adrian Bolinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageSegmentedControl: UISegmentedControl!
  @IBOutlet weak var imageAlphaLabel: UILabel!
  @IBOutlet weak var imageAlphaSlider: UISlider!
  @IBOutlet weak var blurAlphaLabel: UILabel!
  @IBOutlet weak var blurAlphaSlider: UISlider!
  @IBOutlet weak var topSegmentedControl: UISegmentedControl!
  @IBOutlet weak var bottomSegmentedControl: UISegmentedControl!
  @IBOutlet weak var resetButton: UIButton!
  
  // MARK: - Lifecycle Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure topSegmentedControl
    let topOptions = ["extraLight", "light", "dark"]
    
    for index in 0..<topOptions.count {
      self.topSegmentedControl.setTitle(topOptions[index], forSegmentAt: index)
    }
    
    // configure bottomSegmentedControl
    let bottomOptions = ["regular", "prominent", "none"]
    
    for index in 0..<bottomOptions.count {
      self.bottomSegmentedControl.setTitle(bottomOptions[index], forSegmentAt: index)
    }
    
    [imageView, resetButton].forEach{
      $0.layer.cornerRadius = 10.0
    }
  }
  
  // MARK: - Helpers
  
  func addBlurEffect(_ style: UIBlurEffectStyle, blurAlpha: CGFloat = 1.0) {
    /*
     ** DON'T USE ALPHA ON UIVisualEffectView **
     
     I put it in here just to see what the dire warnings were about.
     */
    let overlay = UIVisualEffectView()
    overlay.frame = self.imageView.bounds
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    imageView.addSubview(overlay)
    UIView.animate(withDuration: 1.0) {
      overlay.effect = UIBlurEffect(style: style)
    }
  }
  
  func removeBlurEffect() {
    // remove blur from imageView
    let blurredEffectViews = imageView.subviews.filter{$0 is UIVisualEffectView}
    blurredEffectViews.forEach{ blurEffectView in
      UIView.animate(withDuration: 1.0, animations: {
        (blurEffectView as! UIVisualEffectView).effect = nil
      }, completion: { _ in
        blurEffectView.removeFromSuperview()
      })
    }
  }
  
  // MARK: - IBActions
  
  @IBAction func imageSegmentedControlAction(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      imageView.image = UIImage(named: ImageExample.daylight)
    case 1:
      imageView.image = UIImage(named: ImageExample.overcast)
    case 2:
      imageView.image = UIImage(named: ImageExample.night)
    case 3:
      imageView.image = UIImage(named: ImageExample.indoor)
    case 4:
      imageView.image = UIImage(named: ImageExample.badDay)
    default:
      break
    }
  }
  
  @IBAction func imageAlphaSliderAction(_ sender: UISlider) {
    imageView.alpha = CGFloat(sender.value)
    
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 2
    
    let alphaString = numberFormatter.string(from: NSNumber(value: sender.value))
    imageAlphaLabel.text = "imageView.alpha = \(alphaString ?? "invalid")"
  }
  
  
  @IBAction func blurAlphaSliderAction(_ sender: UISlider) {
    /* BlurView is always nuked when making a new selection, so first will
       always be the one you want
    */
    let blurEffectView = imageView.subviews.filter{$0 is UIVisualEffectView}.first
    guard let blurView = blurEffectView else { return }
    blurView.alpha = CGFloat(sender.value)
    
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 2
    
    let alphaString = numberFormatter.string(from: NSNumber(value: sender.value))
    blurAlphaLabel.text = "blur.alpha = \(alphaString ?? "invalid")"
  }
  
  
  @IBAction func topSegmentedControlAction(_ sender: UISegmentedControl) {
    
    bottomSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    
    // clean up the image to start fresh
    removeBlurEffect()
    
    switch sender.selectedSegmentIndex {
    case 0:
      addBlurEffect(.extraLight)
    case 1:
      addBlurEffect(.light)
    case 2:
      addBlurEffect(.dark)
    default:
      break
    }
  }
  
  @IBAction func bottomSegmentedControlAction(_ sender: UISegmentedControl) {
    
    topSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    
    // clean up the image to start fresh
    removeBlurEffect()
    
    switch sender.selectedSegmentIndex {
    case 0:
      addBlurEffect(.regular)
    case 1:
      addBlurEffect(.prominent)
    case 2:
      removeBlurEffect()
    default:
      break
    }
  }

  @IBAction func resetButtonAction(_ sender: Any) {
    removeBlurEffect()
    
    // set imageView.alpha back to 1.0
    imageView.alpha = 1.0
    imageAlphaSlider.setValue(1.0, animated: true)
    
    // deselect segmentedControls
    [topSegmentedControl, bottomSegmentedControl].forEach{ segmentedControl in
      segmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
    }
  }
}

