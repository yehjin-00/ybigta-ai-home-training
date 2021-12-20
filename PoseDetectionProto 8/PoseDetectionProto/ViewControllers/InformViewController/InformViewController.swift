//
//  InformViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/25.
//

import UIKit

class InformViewController : UIViewController {
    
    
    
    var pageControl: UIPageControl!
    var exerKind: String!
    var informview: UIImageView!
    var images = ["s1", "s2", "s3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //checkingView()
        informView()
        addNextButton()
        addPrevButton()
        addOKButton()
        
        if exerKind == "SQUAT"{
        }
    }
    func addNextButton(){
        let nextButton = UIButton(frame: CGRect(x: view.frame.width * 0.7,
                                              y: view.frame.height * 0.8,
                                              width: view.frame.width * 0.2,
                                              height: view.frame.height * 0.05))
        nextButton.setTitle("다음", for: UIControl.State.normal)
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.backgroundColor = .lightGray
        nextButton.alpha = 0.7
        nextButton.addTarget(self, action: #selector(pageChangeup), for :UIControl.Event.touchUpInside)
        view.addSubview(nextButton)
    }
    func addPrevButton(){
        let prevButton = UIButton(frame: CGRect(x: view.frame.width * 0.1,
                                              y: view.frame.height * 0.8,
                                              width: view.frame.width * 0.2,
                                              height: view.frame.height * 0.05))
        prevButton.setTitle("다음", for: UIControl.State.normal)
        prevButton.setTitleColor(.white, for: UIControl.State.normal)
        prevButton.backgroundColor = .lightGray
        prevButton.alpha = 0.7
        prevButton.addTarget(self, action: #selector(pageChangedown), for : UIControl.Event.touchUpInside)
        view.addSubview(prevButton)
    }
    
    func informView(){
        informview = UIImageView(frame: CGRect(x: view.frame.minX,
                                               y: view.frame.height * 0,
                                               width: view.frame.width,
                                               height: view.frame.height * 0.8))
        informview.contentMode = .scaleAspectFit
        
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                y: self.view.frame.maxY - 215,
                                                width: self.view.frame.maxX,
                                                height:50))

        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        informview.image = UIImage(named: images[pageControl.currentPage])
        
        pageControl.addTarget(self, action: #selector(pageChangeup), for: .touchDragEnter)
        pageControl.addTarget(self, action: #selector(pageChangedown), for: .touchDragExit)

        
        view.addSubview(self.informview)
        view.addSubview(self.pageControl)
    }
    
    @objc
    func pageChangeup(){
        pageControl.currentPage += 1
        informview.image = UIImage(named: images[pageControl.currentPage])
    }
    @objc
    func pageChangedown(){
        pageControl.currentPage -= 1
        informview.image = UIImage(named: images[pageControl.currentPage])
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
        okButton.backgroundColor = .gray
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
    /*
    @IBAction func pageChange(_ sender: UIPageControl) {
        imgView.image = UIImage(named: images[pageControl.currentPage])
    }
    */
}
