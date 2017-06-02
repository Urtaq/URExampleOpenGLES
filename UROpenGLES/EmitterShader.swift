//
//  EmitterShader.swift
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 5. 2..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation
import GLKit

let emitterVS = "// Attributes\n" +
    "attribute float aTheta;\n" +
    "\n" +
    "// Uniforms\n" +
    "uniform mat4 uProjectionMatrix;\n" +
    "uniform float uK;\n" +
    "\n" +
    "void main(void)\n" +
    "{\n" +
    "  float x = cos(uK * aTheta) * sin(aTheta);\n" +
    "  float y = cos(uK * aTheta) * cos(aTheta);\n" +
    "\n" +
    "  gl_Position = uProjectionMatrix * vec4(x, y, 0.0, 1.0);\n" +
    "  gl_PointSize = 16.0;\n" +
"}"

let emitterFS = "void main(void) {\n" +
    "  gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n" +
"}"

@objc
class EmitterShader: NSObject {
    var program: GLuint = 0

    var aTheta: GLint = 0

    var uProjectionMatrix: GLint = 0
    var uK: GLint = 0

    func loadShader() {
        let shaderProcessor: ShaderProcessor = ShaderProcessor()
        self.program = shaderProcessor.buildProgram((emitterVS as NSString).utf8String, with: (emitterFS as NSString).utf8String)

        self.aTheta = glGetAttribLocation(self.program, "aTheta")

        self.uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix")
        self.uK = glGetUniformLocation(self.program, "uK")
    }
}
