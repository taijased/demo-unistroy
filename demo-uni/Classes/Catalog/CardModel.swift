
import Foundation

import UIKit

struct CardModel {
    var mainImage: UIImage
    var cardName: String
    var modelPath: String
    
    static func fetchCard() -> [CardModel] {
        let item_1 = CardModel(mainImage: UIImage(named: "sofa")!,
                                  cardName: "Диван", modelPath: "assets.scnassets/sofa/Sofa.scn" )
        let item_2 = CardModel(mainImage: UIImage(named: "chair_2")!,
                               cardName: "Стул", modelPath: "assets.scnassets/chair_2/Chair2.scn")
        let item_3 = CardModel(mainImage: UIImage(named: "chair")!,
                                cardName: "Кресло", modelPath: "assets.scnassets/chair/Chair.scn")
        let item_4 = CardModel(mainImage: UIImage(named: "chair_4")!,
                               cardName: "Кресло", modelPath: "assets.scnassets/chair_4/Chair4.scn")
        let item_5 = CardModel(mainImage: UIImage(named: "chair_3")!,
                                cardName: "Кресло", modelPath: "assets.scnassets/chair_3/Chair3.scn")
        let item_6 = CardModel(mainImage: UIImage(named: "Table")!,
                               cardName: "Стол", modelPath: "assets.scnassets/Table/Table.scn")
        let item_7 = CardModel(mainImage: UIImage(named: "table_2")!,
                               cardName: "Стол", modelPath: "assets.scnassets/table_2/Table3.scn")
        let item_8 = CardModel(mainImage: UIImage(named: "lamp_1")!,
                               cardName: "Лампа", modelPath: "assets.scnassets/lamp_1/Lamp2.scn")
        return [item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8]
    }
    static func fetcTexture() -> [CardModel] {

        let item_1 = CardModel(mainImage: UIImage(named: "wall1")!, cardName: "Обои", modelPath: "assets.scnassets/images/wall1.jpg")
        let item_2 = CardModel(mainImage: UIImage(named: "wall2")!, cardName: "Обои", modelPath: "assets.scnassets/images/wall2.jpg")
        let item_3 = CardModel(mainImage: UIImage(named: "wall3")!, cardName: "Кирпич", modelPath: "assets.scnassets/images/wall3.jpg")
        let item_4 = CardModel(mainImage: UIImage(named: "wall4")!, cardName: "Красная краска", modelPath: "assets.scnassets/images/wall4.jpg")
        let item_5 = CardModel(mainImage: UIImage(named: "wall5")!, cardName: "Серая краска", modelPath: "assets.scnassets/images/wall5.jpg")
        
        return [item_1, item_2, item_3, item_4, item_5]
    }
}

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.galleryMinimumLineSpacing / 2)) / 2
}
