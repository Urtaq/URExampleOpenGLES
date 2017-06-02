//
//  EmitterTemplate.swift
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 5. 2..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

let NumParticles: Int = 360

struct Particle {
    var theta: Float
    var shade: [Float] = Array<Float>(repeating: 0.0, count: 3)

    init() {
        self.theta = 0.0
    }
}

struct Emitter {
    var particles: [Particle] = Array(repeating: Particle(), count: NumParticles)
    var k: Int
    var color: [Float] = Array<Float>(repeating: 0.0, count: 3)

    init() {
        self.k = 0
    }
}
