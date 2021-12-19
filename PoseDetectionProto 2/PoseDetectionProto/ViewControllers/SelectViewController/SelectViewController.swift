//
//  startViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/22.
//
import UIKit
import Foundation

class SelectViewController: UIViewController{
    
    
    var requireExer: UILabel!
    var requireExer2: UILabel!
    var plankButton: UIButton!
    var squatButton: UIButton!
    var pushupButton: UIButton!
    var lungeButton: UIButton!
    var sideButton: UIButton!
    var situpButton: UIButton!

    var upperImg: UIImage!
    var upperImgview: UIImageView!
    
    /*
     var logoImgView: UIImageView!
     var logoImg: UIImage!
     */
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        loadupperimg()
        createOutlet()
        createOutlet2()
        selectExerButton()
        
    }
    func loadupperimg(){
        upperImg = UIImage(named: "그림1")
        
        upperImgview = UIImageView(frame: CGRect(x: view.frame.minX,
                                                 y: view.frame.minY,
                                                 width: view.frame.width,
                                                 height: view.frame.height*0.2) )
        upperImgview.image = upperImg
        upperImgview.contentMode = .scaleAspectFill
        upperImgview.layer.shadowOffset = CGSize(width: 5, height: 5)
        upperImgview.layer.shadowOpacity = 0.7
        upperImgview.layer.shadowRadius = 5
        upperImgview.layer.shadowColor = UIColor.gray.cgColor
        
        
        view.addSubview(upperImgview)
        print("here")
        
        
    }
    /*
    func loadLogoimg(){
        logoImg = UIImage(named: "logo")
        
        logoImgView = UIImageView(frame: CGRect(x: view.frame.width * 0.2,
                                                y: view.frame.height * 0.35,
                                                width: view.frame.width * 0.6,
                                                height: view.frame.height/8))
        logoImgView.backgroundColor = .white
        logoImgView.image = logoImg
        logoImgView.contentMode = .scaleAspectFill
        
        // 둥근 테두리
//        logoImgView.layer.cornerRadius = 100
//        logoImgView.clipsToBounds = true
    
        // 그림자 clipsToBounds하니까 그림자까지 잘림
        logoImgView.layer.shadowOffset = CGSize(width: 5, height: 5)
        logoImgView.layer.shadowOpacity = 0.7
        logoImgView.layer.shadowRadius = 5
        logoImgView.layer.shadowColor = UIColor.gray.cgColor
        
        
        view.addSubview(logoImgView)
        print("here")
    }
     */
    
    
    func createOutlet(){
        
        requireExer = UILabel(frame: CGRect(x: view.frame.width*0.1,
                                            y: view.frame.height*0.1,
                                            width: view.frame.width*0.8,
                                            height: view.frame.height*0.1))
        requireExer.backgroundColor = .clear
        
        requireExer.text = "Hey YBIGTA!"
        requireExer.font = UIFont(name: "Apple Color Emoji", size: 30)
        requireExer.textColor = .white
        requireExer.textAlignment = .left
        requireExer.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(requireExer)
        
    }
    
    func createOutlet2(){
        
        requireExer2 = UILabel(frame: CGRect(x: view.frame.width*0.1,
                                            y: view.frame.height*0.15,
                                            width: view.frame.width*0.8,
                                            height: view.frame.height*0.1))
        requireExer2.backgroundColor = .clear
        
        requireExer2.text = "❤️준블리❤️와 함께 운동해요"
        requireExer2.font = UIFont(name: "Apple Color Emoji", size: 20)
        requireExer2.textColor = .white
        requireExer2.textAlignment = .left
        //requireExer.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(requireExer2)
        
    }
    
    func selectExerButton(){
        
        plankButton = UIButton(frame: CGRect(x: view.frame.width*0.05,
                                             y: view.frame.height*0.57,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        //plankButton.layer.cornerRadius = 10
        plankButton.clipsToBounds = false
        plankButton.imageView?.contentMode = .scaleAspectFit
        plankButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        plankButton.layer.shadowOpacity = 0.7
        plankButton.layer.shadowRadius = 5
        plankButton.layer.shadowColor = UIColor.gray.cgColor
        //plankButton.backgroundColor = .red
        plankButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-02-11-20 002"), for: UIControl.State.normal)
        //plankButton.contentMode = .scaleAspectFit
        plankButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        
        
        
        squatButton = UIButton(frame: CGRect(x: view.frame.width*0.525,
                                             y: view.frame.height*0.4,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        
        //squatButton.backgroundColor = .red
        squatButton.clipsToBounds = false
        squatButton.imageView?.contentMode = .scaleAspectFit

        squatButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        squatButton.layer.shadowOpacity = 0.7
        squatButton.layer.shadowRadius = 5
        squatButton.layer.shadowColor = UIColor.gray.cgColor
        
        squatButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-02-11-20 001"), for: UIControl.State.normal)
        squatButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)

        
        
        
        
        
        pushupButton = UIButton(frame: CGRect(x: view.frame.width*0.05,
                                             y: view.frame.height*0.4,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        
        pushupButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-02-11-20 003"), for: UIControl.State.normal)
        pushupButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        //pushupButton.backgroundColor = .red
        pushupButton.clipsToBounds = false
        pushupButton.imageView?.contentMode = .scaleAspectFit

        pushupButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        pushupButton.layer.shadowOpacity = 0.7
        pushupButton.layer.shadowRadius = 5
        pushupButton.layer.shadowColor = UIColor.gray.cgColor
        
        
        
        lungeButton = UIButton(frame: CGRect(x: view.frame.width*0.525,
                                             y: view.frame.height*0.74,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        //plankButton.layer.cornerRadius = 10
        lungeButton.clipsToBounds = false
        lungeButton.imageView?.contentMode = .scaleAspectFit
        lungeButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        lungeButton.layer.shadowOpacity = 0.7
        lungeButton.layer.shadowRadius = 5
        lungeButton.layer.shadowColor = UIColor.gray.cgColor
        //lungeButton.backgroundColor = .red
        lungeButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-03-56-18 001"), for: UIControl.State.normal)
        //plankButton.contentMode = .scaleAspectFit
        lungeButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        
        sideButton = UIButton(frame: CGRect(x: view.frame.width*0.525,
                                             y: view.frame.height*0.57,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        //plankButton.layer.cornerRadius = 10
        sideButton.clipsToBounds = false
        sideButton.imageView?.contentMode = .scaleAspectFit
        sideButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        sideButton.layer.shadowOpacity = 0.7
        sideButton.layer.shadowRadius = 5
        sideButton.layer.shadowColor = UIColor.gray.cgColor
        //plankButton.backgroundColor = .red
        sideButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-03-56-18 002"), for: UIControl.State.normal)
        //plankButton.contentMode = .scaleAspectFit
        sideButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        
        
        situpButton = UIButton(frame: CGRect(x: view.frame.width*0.05,
                                             y: view.frame.height*0.74,
                                             width: view.frame.width*0.425,
                                             height: view.frame.height*0.15))
        //plankButton.layer.cornerRadius = 10
        situpButton.clipsToBounds = false
        situpButton.imageView?.contentMode = .scaleAspectFit
        situpButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        situpButton.layer.shadowOpacity = 0.7
        situpButton.layer.shadowRadius = 5
        situpButton.layer.shadowColor = UIColor.gray.cgColor
        //situpButton.backgroundColor = .red
        situpButton.setImage(UIImage(named: "KakaoTalk_Photo_2021-12-19-03-58-31"), for: UIControl.State.normal)
        //plankButton.contentMode = .scaleAspectFit
        situpButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        
        
        
        view.addSubview(plankButton)
        view.addSubview(squatButton)
        view.addSubview(pushupButton)
        view.addSubview(lungeButton)
        view.addSubview(sideButton)
        view.addSubview(situpButton)
        
    }
    
    @objc func toDetectView(_ sender: UIButton){
        performSegue(withIdentifier: "InformViewSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "InformViewSegue" {
            if let vc = segue.destination as? InformViewController {
                let button = sender as? UIButton
                if button == plankButton {
                    vc.exerKind = "PLANK"
                }else if button == squatButton {
                    vc.exerKind = "SQUAT"
                }else if button == pushupButton {
                    vc.exerKind = "PUSHUP"
                }else if button == sideButton {
                    vc.exerKind = "SOON"
                }else if button == situpButton {
                    vc.exerKind = "SOON"
                }else if button == lungeButton {
                    vc.exerKind = "SOON"
                }else{
                    fatalError("anything came into")
                }
            }
        }
    }
    

}
