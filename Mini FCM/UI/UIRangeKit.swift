//
//  NSRangeKit.swift
//  Editor
//
//  Created by fridakitten on 31.10.24.
//

import Foundation
import UIKit

func findRanges(of word: String, in text: String) -> [NSRange] {
    let nsText = NSString(string: text)
    var ranges: [NSRange] = []

    var searchRange = NSRange(location: 0, length: nsText.length)

    while true {
        let range = nsText.range(of: word, options: [], range: searchRange)

        if range.location == NSNotFound {
            break
        }

        ranges.append(range)

        let newLocation = range.location + range.length
        searchRange = NSRange(location: newLocation, length: nsText.length - newLocation)
    }

    return ranges
}

func setSelectedTextRange(for textView: UITextView, with askedRange: NSRange) {
    guard let text = textView.text,
          askedRange.location != NSNotFound,
          askedRange.location + askedRange.length <= text.count else {
        return
    }

    let caretRange = NSRange(location: askedRange.location + askedRange.length, length: 0)

    let startPosition = textView.position(from: textView.beginningOfDocument, offset: caretRange.location)
    let endPosition = textView.position(from: startPosition!, offset: 0)

    let textRange = textView.textRange(from: startPosition!, to: endPosition!)
    textView.selectedTextRange = textRange
}

func visualRangeRect(in textView: UITextView, for textRange: NSRange) -> CGRect? {
    guard textRange.location != NSNotFound,
          textRange.location + textRange.length <= textView.textStorage.length else {
          return nil
    }

    let layoutManager = textView.layoutManager
    let textContainer = textView.textContainer
    let glyphRange = layoutManager.glyphRange(forCharacterRange: textRange, actualCharacterRange: nil)

    var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

    rect.origin.x += textView.textContainerInset.left
    rect.origin.y += textView.textContainerInset.top

    return rect
}
