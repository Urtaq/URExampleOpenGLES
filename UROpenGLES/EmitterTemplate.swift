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

    init() {
        self.theta = 0.0
    }
}

struct Emitter {
    var particles: [Particle] = Array(repeating: Particle(), count: NumParticles)
    var k: Int

    init() {
        self.k = 0
    }
}

@objc
class CParticle: NSObject {
    var theta: Float

    override init() {
        self.theta = 0.0
    }
}

@objc
class CEmitter: NSObject {
    var particles: [CParticle] = Array(repeating: CParticle(), count: NumParticles)
    var k: Int

    override init() {
        self.k = 0
    }
}
