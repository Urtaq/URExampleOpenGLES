//
//  ShaderProcessor.h
//  UROpenGLES
//
//  Created by DongSoo Lee on 2017. 6. 1..
//  Copyright © 2017년 zigbang. All rights reserved.
//

#import <GLKit/GLKit.h>

static inline ptrdiff_t
offset_of(long * _Nonnull base, long * _Nonnull ptr)
{
    return ptr - base;
}

@interface ShaderProcessor : NSObject

- (GLuint)BuildProgram:(const char*_Nonnull)vertexShaderSource with:(const char*_Nonnull)fragmentShaderSource;

@end
