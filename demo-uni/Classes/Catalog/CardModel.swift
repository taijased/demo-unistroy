
import Foundation

import UIKit

struct CardModel {
    var mainImage: UIImage
    var cardName: String
    
    
    static func fetchCard() -> [CardModel] {
        let firstItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Кресло")
        let secondItem = CardModel(mainImage: UIImage(named: "sushi2")!,
                                   cardName: "Шкаф")
        let thirdItem = CardModel(mainImage: UIImage(named: "sushi3")!,
                                  cardName: "Диван")
        let fouthItem = CardModel(mainImage: UIImage(named: "sushi4")!,
                                  cardName: "Стол")
        let five = CardModel(mainImage: UIImage(named: "sushi1")!,
                             cardName: "Кресло")
        let six = CardModel(mainImage: UIImage(named: "sushi2")!,
                            cardName: "Зеркало")
        let seven = CardModel(mainImage: UIImage(named: "sushi3")!,
                              cardName: "Комод")
        let eight = CardModel(mainImage: UIImage(named: "sushi4")!,
                              cardName: "Шкаф")
        
        
        return [firstItem, secondItem, thirdItem, fouthItem, five, six, seven, eight]
    }
    static func fetcTexture() -> [CardModel] {
        let firstItem = CardModel(mainImage: UIImage(named: "sushi1")!,
                                  cardName: "Обои")
        
        return [firstItem]
    }
}

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.galleryMinimumLineSpacing / 2)) / 2
}
