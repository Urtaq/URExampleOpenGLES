//
//  ViewController.swift
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 5. 2..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController, GLKViewDelegate {

    var emitterShader: EmitterShader!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let context: EAGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES3)
        EAGLContext.setCurrent(context)

        let view: GLKView = self.view as! GLKView
        view.context = context
        view.delegate = self

        self.loadShader()
        self.loadParticles()
        self.loadEmitter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var emitter: Emitter = Emitter()

    func loadParticles() {
        for (i, var particle) in self.emitter.particles.enumerated() {
            particle.theta = GLKMathDegreesToRadians(Float(i))

            self.emitter.particles[i] = particle
        }

        // Create Vertex Buffer Object (VBO)
        var particleBuffer: GLuint = 0
        glGenBuffers(1, &particleBuffer)                                // Generate particle buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), particleBuffer)           // Bind particle buffer
        glBufferData(                                                   // Fill bound buffer with particles
            GLenum(GL_ARRAY_BUFFER),                                    // Buffer target
            MemoryLayout<Particle>.size * self.emitter.particles.count, // Buffer data size
            self.emitter.particles,                                     // Buffer data pointer
            GLenum(GL_STATIC_DRAW)                                      // Usage - Data never changes; used for drawing
        )
    }

    func loadEmitter() {
        self.emitter.k = Int(4.0)
    }

    // MARK: - Load Shader
    func loadShader() {
        self.emitterShader = EmitterShader()
        self.emitterShader.loadShader()
        glUseProgram(self.emitterShader.program);
    }

    // MARK: - GLKViewDelegate
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.3, 0.74, 0.2, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        // 1
        // Create Projection Matrix
        let aspectRatio: Float = Float(view.frame.width / view.frame.height)
        var projectionMatrix: GLKMatrix4 = GLKMatrix4MakeScale(1.0, aspectRatio, 1.0)

        // 2
        // Uniforms
        glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, &projectionMatrix.m.0)
        glUniform1f(self.emitterShader.uK, GLfloat(emitter.k))

        // 3
        // Attributes
        glEnableVertexAttribArray(GLuint(self.emitterShader.aTheta))
        var offset: GLfloat = 0 // GLfloat(MemoryLayout<Float>.size)
        glVertexAttribPointer(GLuint(self.emitterShader.aTheta),    // Set pointer
            1,                                     // One component per particle
            GLenum(GL_FLOAT),                      // Data is floating point type
            GLboolean(GL_FALSE),                   // No fixed point scaling
            GLsizei(MemoryLayout<Particle>.size),  // No gaps in data
            nil)      // Start from "theta" offset within bound buffer

        // 4
        // Draw particles
        glDrawArrays(GLenum(GL_POINTS), 0, GLsizei(NumParticles))
        glDisableVertexAttribArray(GLuint(self.emitterShader.aTheta))
    }
}

