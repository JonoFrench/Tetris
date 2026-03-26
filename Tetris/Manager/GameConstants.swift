//
//  GameConstants.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import CoreGraphics
import SwiftUI

public enum GameState {
    case intro,playing,highscore,paused,gameover,gameending
}

public enum GameConstants {
    
    public enum Game {
        public static let tilesWide = 10.0
        public static let tilesHigh = 20.0
    }
    ///Higher speed = slower
    public enum Speed {
        public static let tileSteps = 8.0
   }
    
    public enum Size {
#if os(iOS)
        public static let blockSize = CGSize(width: 30, height: 30)
        public static let pointsSize = CGSize(width: 40, height: 24)
        public static let typeSize = 30.0

#elseif os(tvOS)
        public static let blockSize = CGSize(width: 30, height: 30)
        public static let pointsSize = CGSize(width: 40, height: 24)
        public static let typeSize = 30.0
#endif
    }
    
    public enum Text {
#if os(iOS)
        public static let startText = "PRESS FIRE TO START"
        public static let starttextSize:CGFloat = 14
        public static let copyTextSize:CGFloat = 12
        public static let titleTextSize:CGFloat = 18
        public static let extraTextSize:CGFloat = 18
        public static let highScoreTextSize:CGFloat = 24
        public static let subTitleTextSize:CGFloat = 12
        public static let scoreTextSize:CGFloat = 16
        public static let letterTextSize:CGFloat = 30

#elseif os(tvOS)
        public static let startText = "PRESS A TO START"
        public static let starttextSize:CGFloat = 24
        public static let copyTextSize:CGFloat = 22
        public static let titleTextSize:CGFloat = 28
        public static let extraTextSize:CGFloat = 36
        public static let highScoreTextSize:CGFloat = 36
        public static let subTitleTextSize:CGFloat = 18
        public static let scoreTextSize:CGFloat = 22
        public static let letterTextSize:CGFloat = 60
#endif
    }
    
    public enum Delay {
        public static let levelEndDelay = 3.5

    }
    
    public enum Score {
        public static let one = 40
        public static let two = 100
        public static let three = 300
        public static let four = 1200
    }
    
    public enum Sound {
        public static let effectsVolume:Float = 1.0
        public static let backgroundVolume:Float = 1.0
        public static let musicVolume:Float = 1.0
    }
}
