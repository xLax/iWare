import Foundation
import UIKit

class ImageCacheService {
    
    static let shareInstance: ImageCacheService = ImageCacheService()
    
    private init() { }
    
    static func saveImageToFile(image:UIImage, imageId:String){
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageId)
            try? data.write(to: filename)
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func getImageFromFile(imageId:String, callback:@escaping (UIImage?)->Void){
        let filename = getDocumentsDirectory().appendingPathComponent(imageId)
        callback(UIImage(contentsOfFile:filename.path))
    }
}

