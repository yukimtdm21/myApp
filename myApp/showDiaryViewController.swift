

import UIKit
import CoreData
import Photos

class showDiaryViewController: UIViewController {

    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDate2: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var textToWrite: UITextView!
    
    var diaryList = NSMutableArray()
    
    var selectedNomber:Int = -1
    var scdiaryList:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedNomber)
        
         read()
        
        let dic = diaryList[selectedNomber] as! NSDictionary
        
        print(dic)
        
        myTitle?.text = dic["title"] as! String
   
        textToWrite?.text = dic["content"] as! String
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyy/MM/dd"
//        let dateString: String = dateFormatter.string(from: myDate?)
//        myDate?.text = dic["startdate"] as! String
        
        //画像角落とす
        self.firstImage.layer.cornerRadius = 35
        self.firstImage.layer.masksToBounds = true
        //枠線
        self.firstImage.layer.borderColor = UIColor.black.cgColor
        self.firstImage.layer.borderWidth = 1
        
        
        let strURL =  dic["image1"] as! String
        if strURL != nil{
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
                manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                
                    self.firstImage.image = image
            }
            
        }
        print(diaryList)
        
    }

    func read(){
        
        diaryList = NSMutableArray()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let myRequest = NSEntityDescription.entity(forEntityName: "DIARY", in: viewContext)
        
        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                let content: String? = result.value(forKey:"content") as? String
                
                let image1: String? = result.value(forKey: "image1") as? String
                
                let startDate: Date? = result.value(forKey: "startDate") as? Date
                
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                
                //("title:\(title) saveDate:\(saveDate)")
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"content":content,"startDate":startDate,"endDate":endDate])
            }
            
        }catch{
        }
    }
    
    @IBAction func tapToShare(_ sender: UIBarButtonItem) {
        
        //アクティビティービュー作成
        let controller = UIActivityViewController(activityItems: [firstImage.image], applicationActivities: nil)
        
        //アクティビティービュー表示
        present(controller, animated: true, completion: nil)

    }
    
    @IBAction func tapToBack(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  }
