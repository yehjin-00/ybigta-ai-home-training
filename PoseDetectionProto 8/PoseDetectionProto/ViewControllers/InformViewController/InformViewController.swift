//
//  InformViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/25.
//

import UIKit

class InformViewController : UIViewController {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    
    var exerKind: String!
    
    var images = ["squat01", "squat02", "squat03"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //checkingView()
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        imgView.image = UIImage(named: images[0])
        
        addOKButton()
        
        if exerKind == "SQUAT"{
            
        }
        
    }
    
    func checkingView(){
        let label = UILabel(frame: CGRect(x: view.frame.width*0.2, y: view.frame.height*0.05, width: view.frame.width * 0.6, height: view.frame.height * 0.1))
        label.text = exerKind
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Apple Color Emoji", size: 30)
        label.backgroundColor = .blue
        label.alpha = 0.7
        label.layer.cornerRadius = 20
        
        
        let inform = UIImage(named: "information")
        let informview = UIImageView(frame: CGRect(x: view.frame.minX,
                                                   y: view.frame.height * 0.1,
                                                   width: view.frame.width,
                                                   height: view.frame.height * 0.8))
        informview.contentMode = .scaleAspectFit
        informview.image = inform
        
        view.addSubview(label)
        view.addSubview(informview)
        print(exerKind)
    }
    
    func addOKButton(){
        let okButton = UIButton(frame: CGRect(x: view.frame.width * 0.4,
                                              y: view.frame.height * 0.8,
                                              width: view.frame.width * 0.2,
                                              height: view.frame.height * 0.05))
        okButton.setTitle("OK", for: UIControl.State.normal)
        okButton.setTitleColor(.white, for: UIControl.State.normal)
        okButton.backgroundColor = .blue
        okButton.alpha = 0.7
        okButton.addTarget(self, action: #selector(toPoseDetectionView), for: UIControl.Event.touchUpInside)
        view.addSubview(okButton)
    }
    
    @objc func toPoseDetectionView(_ sender: UIButton){
        performSegue(withIdentifier: "DetectViewSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "DetectViewSegue" {
            if let vc = segue.destination as? PoseDetectViewController {
                vc.exerKind = exerKind
            }
        }
    }
    @IBAction func pageChange(_ sender: UIPageControl) {
        imgView.image = UIImage(named: images[pageControl.currentPage])
    }
    
}
