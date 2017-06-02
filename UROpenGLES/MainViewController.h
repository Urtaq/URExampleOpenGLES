//
//  MainViewController.h
//  UROpenGLES2
//
//  Created by DongSoo Lee on 2017. 6. 2..
//  Copyright © 2017년 zigbang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct Particle
{
    float       theta;
    float       shade[3];
}
Particle;

typedef struct Emitter
{
    Particle    particles[NUM_PARTICLES];
    int         k;
    float       color[3];
}
Emitter;

Emitter emitter = {0.0f};

@interface MainViewController : GLKViewController

@end

