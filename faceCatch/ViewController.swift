//
//  ViewController.swift
//  faceCatch
//
//  Created by Eriko Ichinohe on 2016/08/31.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage{
    
    // UIImageをリサイズするメソッド.
    class func ResizeUIImage(image : UIImage,width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        
        // コンテキストに自身に設定された画像を描画する.
        image.drawInRect(CGRectMake(0, 0, width, height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myImage : UIImage = UIImage.ResizeUIImage(UIImage(named: "sample.jpg")!, width: 400, height: 300)
        
        // UIImageViewの生成.
        let myImageView : UIImageView = UIImageView()
        myImageView.frame = CGRectMake(0, 20, myImage.size.width, myImage.size.height)
        myImageView.image = myImage
        self.view.addSubview(myImageView)
        
        // NSDictionary型のoptionを生成。顔認識の精度を追加する.
        var options : NSDictionary = NSDictionary(object: CIDetectorAccuracyHigh, forKey: CIDetectorAccuracy)
        
        // CIDetectorを生成。顔認識をするのでTypeはCIDetectorTypeFace.
        var detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as! [String : AnyObject])
        
        // detectorで認識した顔のデータを入れておくNSArray.
        var faces : NSArray = detector.featuresInImage(CIImage(image: myImage)!)
        
        // UIKitは画面左上に原点があるが、CoreImageは画面左下に原点があるのでそれを揃えなくてはならない.
        // CoreImageとUIKitの原点を画面左上に統一する処理.
        var transform : CGAffineTransform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -myImageView.bounds.size.height)
        
        // 検出された顔のデータをCIFaceFeatureで処理.
        var feature : CIFaceFeature = CIFaceFeature()
        for feature in faces {
            
            // 座標変換.
            let faceRect : CGRect = CGRectApplyAffineTransform(feature.bounds, transform)
            
            // 画像の顔の周りを線で囲うUIViewを生成.
            var faceOutline = UIView(frame: faceRect)
            faceOutline.layer.borderWidth = 1
            faceOutline.layer.borderColor = UIColor.redColor().CGColor
            myImageView.addSubview(faceOutline)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

