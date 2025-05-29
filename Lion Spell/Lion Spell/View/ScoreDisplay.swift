//
//  ScoreDisplay.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/1/24.
//

import SwiftUI

struct ScoreDisplay: View {
    var score : WordManager
    
    var body: some View {
        Text("\(score.score)")
            .bold()
            .font(.system(size: 50))
    }
}

#Preview {
    let currScore = WordManager(score: 4)
    return ScoreDisplay(score: currScore)
}
