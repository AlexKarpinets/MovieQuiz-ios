//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Karpinets Alexander on 04.02.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    
    let correct: Int
    let total: Int
    let date: Date

//    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
//        if lhs.correct < rhs.total {
//            return true
//        }
//        return true
//        }
    }
