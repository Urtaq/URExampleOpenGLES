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
    "attribute vec3 aShade;\n" +
    "\n" +
    "// Uniforms\n" +
    "uniform mat4 uProjectionMatrix;\n" +
    "uniform float uK;\n" +
    "\n" +
    "// Output to Fragment Shader\n" +
    "varying vec3 vShade;\n" +
    "uniform float uTime;\n" +
    "\n" +
    "void main(void)\n" +
    "{\n" +
    "  float x = uTime * cos(uK * aTheta) * sin(aTheta);\n" +
    "  float y = uTime * cos(uK * aTheta) * cos(aTheta);\n" +
    "\n" +
    "  gl_Position = uProjectionMatrix * vec4(x, y, 0.0, 1.0);\n" +
    "  gl_PointSize = 16.0;\n" +
    "\n" +
    "  vShade = aShade;\n" +
"}"

let emitterFS =
    "// Input from Vertex Shader\n" +
        "varying highp vec3 vShade;\n" +
        "\n" +
        "// Uniforms\n" +
        "uniform highp vec3 uColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "\n" +
    "void main(void) {\n" +
//    "  gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n" +
        "highp vec4 texture = texture2D(uTexture, gl_PointCoord);\n" +
        "highp vec4 color = vec4((uColor+vShade), 1.0);\n" +
        "color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));\n" +
        "gl_FragColor = texture * color;\n" +
"}"

@objc
class EmitterShader: NSObject {
    var program: GLuint = 0

    var aTheta: GLint = 0

    var uProjectionMatrix: GLint = 0
    var uK: GLint = 0

    var aShade: GLint = 0
    var uColor: GLint = 0

    var uTime: GLint = 0

    var uTexture: GLint = 0

    func loadShader() {
        let shaderProcessor: ShaderProcessor = ShaderProcessor()
        self.program = shaderProcessor.buildProgram((emitterVS as NSString).utf8String!, with: (emitterFS as NSString).utf8String!)

        self.aTheta = glGetAttribLocation(self.program, "aTheta")

        self.uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix")
        self.uK = glGetUniformLocation(self.program, "uK")

        // with the other attributes
        self.aShade = glGetAttribLocation(self.program, "aShade");

        // with the other uniforms
        self.uColor = glGetUniformLocation(self.program, "uColor");

        self.uTime = glGetUniformLocation(self.program, "uTime");

        self.uTexture = glGetUniformLocation(self.program, "uTexture");
    }
}
