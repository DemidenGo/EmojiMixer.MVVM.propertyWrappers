//
//  EmojiMixFactory.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 17.04.2023.
//

import UIKit

final class EmojiMixFactory {

    private let emojies = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]

    func makeNewMix() -> String {
        var mix = ""
        for _ in 0...2 {
            guard let randomEmoji = emojies.randomElement() else { return "" }
            mix.append(randomEmoji)
        }
        return mix
    }

    func makeColor() -> UIColor {
        let emojiMix = makeNewMix()
        var colorComponents: [CGFloat] = []
        for char in emojiMix {
            let scalars = char.unicodeScalars
            let emojiScalarValue = scalars[scalars.startIndex].value
            let colorComponent: CGFloat = CGFloat(emojiScalarValue % 128) / 255 + 0.25
            colorComponents.append(colorComponent)
        }
        return UIColor(red: colorComponents[0],
                       green: colorComponents[1],
                       blue: colorComponents[2],
                       alpha: 1)
    }
}
