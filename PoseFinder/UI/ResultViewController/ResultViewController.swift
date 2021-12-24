//
//  ResultViewController.swift
//  SantaFit
//
//  Created by JinWoo on 2021/12/24.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController{
    var time: Int!
    var count: String!
    var exerKind: String!
    var exerKindKo: String!
    var sen: UILabel!
    var upperImg2: UIImage!
    var upperImgview2: UIImageView!
    var bubble : UIImage!
    var bubbleview : UIImageView!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        changeName()
        createBubble()
        addDDabong()
        createSen()
        addReturnToSelectButton()
    }
    
    func changeName(){
        if exerKind == "SQUAT"{
            exerKindKo = "스쿼트"
        } else if exerKind == "LUNGE"{
            exerKindKo = "런지"
        }else if exerKind == "PLANK"{
            exerKindKo = "플랭크"
        } else if exerKind == "PUSHUP"{
            exerKindKo = "팔굽혀펴기"
        } else if exerKind == "SIDE"{
            exerKindKo = "사이드크런치"
        } else if exerKind == "SITUP"{
            exerKindKo = "윗몸일으키기"
        } else if exerKind == "CORRECT"{
            //exerKindKo = "진단모드"
        }
    }
    
    
    func createSen(){
        sen = UILabel(frame: CGRect(x: view.frame.width*0.1,
                                            y: view.frame.height*0.1,
                                            width: view.frame.width*0.8,
                                            height: view.frame.height*0.3))
        sen.backgroundColor = .clear
        sen.numberOfLines = 3
        sen.text = exerKindKo + " " + count + "번을\n" + String(time) + "초 만에?\n" + "이걸? 좀 치는데?"
        sen.font = UIFont(name: "BMHANNA_11yrs_ttf", size: 35)
        sen.textColor = .black
        sen.textAlignment = .center
        sen.font = UIFont.boldSystemFont(ofSize: 35)
        //requireExer.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(sen)
        
    }
    
    func createBubble(){
        bubble = UIImage(named: "textbubble")
        
        bubbleview = UIImageView(frame: CGRect(x: view.frame.width*0.3,
                                               y: view.frame.height*0.08,
                                                  width: view.frame.width*0.4,
                                                  height: view.frame.height*0.4) )
        bubbleview.image = bubble
        bubbleview.contentMode = .scaleAspectFill
        
        view.addSubview(bubbleview)
    }
    
    func addDDabong(){
        upperImg2 = UIImage(named: "ddabong")
        
        upperImgview2 = UIImageView(frame: CGRect(x: view.frame.width*0.1,
                                                  y: view.frame.height*0.37,
                                                  width: view.frame.width*0.4,
                                                  height: view.frame.height*0.4) )
        upperImgview2.image = upperImg2
        upperImgview2.contentMode = .scaleAspectFill
        upperImgview2.layer.shadowOffset = CGSize(width: 5, height: 5)
        upperImgview2.layer.shadowOpacity = 0.7
        upperImgview2.layer.shadowRadius = 5
        upperImgview2.layer.shadowColor = UIColor.gray.cgColor
        
        
        view.addSubview(upperImgview2)
        
    }
    
    func addReturnToSelectButton(){
        let returnButton = UIButton(frame: CGRect(x: view.frame.minX,
                                                  y: view.frame.height * 0.63,
                                                  width: view.frame.width,
                                                  height: view.frame.height * 0.51))
        returnButton.clipsToBounds = false
        returnButton.imageView?.contentMode = .scaleAspectFit
        returnButton.setImage(UIImage(named: "Homebutton"), for: UIControl.State.normal)
        
        returnButton.contentMode = .scaleAspectFill
        returnButton.addTarget(self, action: #selector(toSelectViewController), for: UIControl.Event.touchUpInside)
        
        view.addSubview(returnButton)
    }
    @objc func toSelectViewController(_ sender: UIButton){
        performSegue(withIdentifier: "HongSegue", sender: sender)
    }
}
