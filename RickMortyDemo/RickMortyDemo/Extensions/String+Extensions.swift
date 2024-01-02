
import SwiftUI

extension String {
    static func formatEpisodeCode(_ code: String) -> String {
        let splitCode = code.split(separator: "E", maxSplits: 1, omittingEmptySubsequences: true)
        
        if splitCode.count == 2, let season = Int(splitCode[0].dropFirst()), let episode = Int(splitCode[1]) {
            return "Season \(season), Episode \(episode)"
        } else {
            return "Invalid episode code"
        }
    }
}
