//
//  ViewController.swift
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 5. 2..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {

    var emitterShader: EmitterShader!

    // Instance variables
    private var _timeCurrent: Float = 0.0
    private var _timeMax: Float = 0.0
    private var _timeDirection: Int32 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let context: EAGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES3)
        EAGLContext.setCurrent(context)

        let view: GLKView = self.view as! GLKView
        view.context = context
        view.delegate = self

        // Initialize variables
        _timeCurrent = 0.0;
        _timeMax = 3.0;
        _timeDirection = 1;

        self.loadShader()
        // Load Texture
        self.loadTexture("texture_32.png")
//        self.loadTexture(with: #imageLiteral(resourceName: "texture_32"))
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

            // Assign a random shade offset to each particle, for each RGB channel
            self.emitter.particles[i].shade[0] = self.randomFloatBetween(-0.25, and: 0.25);
            self.emitter.particles[i].shade[1] = self.randomFloatBetween(-0.25, and: 0.25);
            self.emitter.particles[i].shade[2] = self.randomFloatBetween(-0.25, and: 0.25);
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

        self.emitter.color[0] = 0.76;   // Color: R
        self.emitter.color[1] = 0.12;   // Color: G
        self.emitter.color[2] = 0.34;   // Color: B
    }

    func update() {
        if _timeCurrent > _timeMax {
            _timeDirection = -1
        } else if _timeCurrent < 0.0 {
            _timeDirection = 1
        }

        _timeCurrent += Float(_timeDirection) * Float(self.timeSinceLastUpdate)
    }

    // MARK: - Load Shader
    func loadShader() {
        self.emitterShader = EmitterShader()
        self.emitterShader.loadShader()
        glUseProgram(self.emitterShader.program);
    }

    func randomFloatBetween(_ min: Float, and max: Float) -> Float {
        let range: Float = max - min
        return ((Float(arc4random() % (UInt32(RAND_MAX) + 1)) / Float(RAND_MAX)) * range) + min
    }

    // MARK: -Load Texture
    func loadTexture(_ fileName: String) {
        let options = [GLKTextureLoaderOriginBottomLeft: NSNumber(booleanLiteral: true)]

        let path: String = Bundle.main.path(forResource: fileName, ofType: nil)!
        let texture: GLKTextureInfo! = try? GLKTextureLoader.texture(withContentsOfFile: path, options: options)
        if texture == nil {
            print("Error loading file")
        }

        glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
    }

    func loadTexture(with image: UIImage) {
        let options = [GLKTextureLoaderOriginBottomLeft: NSNumber(booleanLiteral: true)]

        let texture: GLKTextureInfo! = try? GLKTextureLoader.texture(with: image.cgImage!, options: options)
        if texture == nil {
            print("Error loading file")
        }

        glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
    }

    // MARK: - GLKViewDelegate
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.3, 0.74, 0.2, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        // Set the blending function (normal w/ premultiplied alpha)
        glEnable(GLenum(GL_BLEND));
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));

        // 1
        // Create Projection Matrix
        let aspectRatio: Float = Float(view.frame.width / view.frame.height)
        var projectionMatrix: GLKMatrix4 = GLKMatrix4MakeScale(1.0, aspectRatio, 1.0)

        // 2
        // Uniforms
        glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, &projectionMatrix.m.0)
        glUniform1f(self.emitterShader.uK, GLfloat(self.emitter.k))
        glUniform3f(self.emitterShader.uColor, self.emitter.color[0], self.emitter.color[1], self.emitter.color[2]);
        glUniform1f(self.emitterShader.uTime, (_timeCurrent/_timeMax));
        glUniform1i(self.emitterShader.uTexture, 0);

        // 3
        // Attributes
        glEnableVertexAttribArray(GLuint(self.emitterShader.aTheta))
        let offset1: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: 0)
        glVertexAttribPointer(GLuint(self.emitterShader.aTheta),    // Set pointer
            1,                                     // One component per particle
            GLenum(GL_FLOAT),                      // Data is floating point type
            GLboolean(GL_FALSE),                   // No fixed point scaling
            GLsizei(MemoryLayout<Particle>.size),  // No gaps in data
            offset1)      // Start from "theta" offset within bound buffer
        glEnableVertexAttribArray(GLuint(self.emitterShader.aShade));

        let offset2: UnsafeRawPointer = UnsafeRawPointer(bitPattern: MemoryLayout<Float>.size)!
        glVertexAttribPointer(GLuint(self.emitterShader.aShade),                // Set pointer
            3,                                        // Three components per particle
            GLenum(GL_FLOAT),                                 // Data is floating point type
            GLboolean(GL_FALSE),                                 // No fixed point scaling
            GLsizei(MemoryLayout<Particle>.size),              // No gaps in data
            offset2);      // Start from "shade" offset within bound buffer

        // 4
        // Draw particles
        glDrawArrays(GLenum(GL_POINTS), 0, GLsizei(NumParticles))
        glDisableVertexAttribArray(GLuint(self.emitterShader.aTheta))
        glDisableVertexAttribArray(GLuint(self.emitterShader.aShade));
    }
}

