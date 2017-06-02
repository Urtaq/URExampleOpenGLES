//
//  ShaderProcessor.h
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 6. 1..
//  Copyright © 2017년 zigbang. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderProcessor : NSObject

- (GLuint)BuildProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource;

@end
