//
//  BAFillableStar.m
//
//  Created by Sanjeev Paskaradevan on 15/04/09.
//
//  Copyright 2009 (c) BeefyApps. www.beefyapps.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "BAFillableStar.h"

// private methods
@interface BAFillableStar (Private)
-(void) fillStarInContext:(CGContextRef)context withRect:(CGRect)rect;
-(void) fillBackgroundOfContext:(CGContextRef)context withRect:(CGRect)rect;
-(void) drawStarOutlineInContext:(CGContextRef)context withRect:(CGRect)rect;
@end

@implementation BAFillableStar
@synthesize fillPercent, fillColor, backgroundColor, strokeColor, fillPercent, lineWidth;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // a normalized star points array
		
		points[0] = CGPointMake(0.5,0.025);
		points[1] = CGPointMake(0.654,0.338);
		points[2] = CGPointMake(1,0.388);
		points[3] = CGPointMake(0.75,0.631);
		points[4] = CGPointMake(0.809,0.975);
		points[5] = CGPointMake(0.5,0.813);
		points[6] = CGPointMake(0.191,0.975);
		points[7] = CGPointMake(0.25,0.631);
		points[8] = CGPointMake(0,0.388);
		points[9] = CGPointMake(0.346,0.338);
	
		lineWidth = 2.0;  //default line width
		
		//default colors
		self.fillColor = [UIColor yellowColor];
		self.backgroundColor = [UIColor whiteColor];
		self.strokeColor = [UIColor blackColor];
		
		//scale our normalized points to the dimensions of the rectangle
		for (int i=0; i<10; i++) {
			points[i].x = points[i].x * frame.size.width;
			points[i].y = points[i].y * frame.size.height;
		}
    }
    return self;
}


- (void)drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, true);
	
	CGLayerRef layer = CGLayerCreateWithContext(context, rect.size, NULL);
	CGContextRef layerContext = CGLayerGetContext(layer);

	[self fillBackgroundOfContext:layerContext withRect:rect];
	[self fillStarInContext:layerContext withRect:rect];
	[self drawStarOutlineInContext:layerContext withRect:rect];
	
	CGContextDrawLayerInRect(context, rect, layer);  //draw the layer to the actual drawing context
	
	CGLayerRelease(layer);  //release the layer
}

-(void)drawWithContext:(CGContextRef)context
{
	[self fillBackgroundOfContext:context withRect:self.frame];
	[self fillStarInContext:context withRect:self.frame];
	[self drawStarOutlineInContext:context withRect:self.frame];
	
}

-(void)setFillPercent:(float)inPercent
{
	fillPercent = inPercent;
	[self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
}


@end



@implementation BAFillableStar (Private)
-(void) fillBackgroundOfContext:(CGContextRef)context withRect:(CGRect)rect;
{
	CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
	CGContextFillRect(context, rect);
}

-(void) fillStarInContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
	//create the path using our points array
	CGContextBeginPath(context);
	CGContextAddLines(context, points, 10);  
	CGContextClosePath(context);
	CGContextClip(context);  //clip drawing to the area defined by this path

	rect.size.width = rect.size.width * fillPercent;  //we want make the width of the rect
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
	CGContextFillRect(context, rect);
	
	CGContextRestoreGState(context);
	
}

-(void) drawStarOutlineInContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextBeginPath(context);
	CGContextAddLines(context, points, 10);  //create the path
	CGContextClosePath(context);
	//set the properties for the line
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
	
	//stroke the path
	CGContextStrokePath(context);
}
@end
