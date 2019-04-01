
import Foundation

import UIKit

struct CardModel {
    var mainImage: UIImage
    var cardName: String
    var modelPath: String
    
    static func fetchCard() -> [CardModel] {
        let firstItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Sofa", modelPath: "assets.scnassets/sofa/Sofa.scn" )
        let secondItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                   cardName: "Шкаф", modelPath: "lexa/eto/ebuchiy/put2")
        let thirdItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Диван", modelPath: "lexa/eto/ebuchiy/put3")
        
        
        
        return [firstItem, secondItem, thirdItem]
    }
    static func fetcTexture() -> [CardModel] {
        let firstItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Обои", modelPath: "assets.scnassets/images/img.jpg")
        let secondItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Лев", modelPath: "assets.scnassets/images/img2.jpg")

        
        return [firstItem, secondItem]
    }
}

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.galleryMinimumLineSpacing / 2)) / 2
}
