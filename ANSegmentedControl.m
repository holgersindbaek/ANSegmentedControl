//
//  ANSegmentedControl.m
//  test01
//
//  Created by Decors on 11/04/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANSegmentedControl.h"
#import "ANSegmentedCell.h"
#import "NSBezierPath+MCAdditions.h"
#import "NSShadow+MCAdditions.h"

@interface ANKnobAnimation : NSAnimation {
    int start, range;
    id delegate;
}

@end

@implementation ANKnobAnimation

- (id)initWithStart:(int)begin end:(int)end
{
    self = [super init];
    if( self )
    {
        start = begin;
        range = end - begin;
    }
    return self;
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    int x = start + progress * range;
    [super setCurrentProgress:progress];
    [delegate performSelector:@selector(setPosition:) 
                   withObject:[NSNumber numberWithInteger:x]];
}

- (void)setDelegate:(id)d
{
    delegate = d;
}

@end

@interface ANSegmentedControl (Private)
- (void)drawBackgroud:(NSRect)rect;
- (void)drawKnob:(NSRect)rect;
- (void)animateTo:(int)x;
- (void)setPosition:(NSNumber *)x;
- (void)offsetLocationByX:(float)x;
- (void)drawCenteredImage:(NSImage*)image inFrame:(NSRect)frame imageFraction:(float)imageFraction;
- (void)setDefaultDurations;
@end

@implementation ANSegmentedControl
@synthesize fastAnimationDuration=_fastAnimationDuration;
@synthesize slowAnimationDuration=_slowAnimationDuration;
@synthesize backgroundImage = _backgroundImage;
@synthesize knobImage = _knobImage;
@synthesize labelFont = _labelFont;
@synthesize textColor = _textColor;

+ (Class)cellClass
{
  return [ANSegmentedCell class];
}
- (id) initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if( self )
    {
        [self setDefaultDurations];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (![aDecoder isKindOfClass:[NSKeyedUnarchiver class]])
    return [super initWithCoder:aDecoder];
        
  NSKeyedUnarchiver *unarchiver = (NSKeyedUnarchiver *)aDecoder;
  Class oldClass = [[self superclass] cellClass];
  Class newClass = [[self class] cellClass];
  
  [unarchiver setClass:newClass forClassName:NSStringFromClass(oldClass)];
  self = [super initWithCoder:aDecoder];
  [unarchiver setClass:oldClass forClassName:NSStringFromClass(oldClass)];
    
    [self setDefaultDurations];
  
  return self;
}

- (void)dealloc
{
    [self setLabelFont:nil];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [self setBoundsSize:NSMakeSize([self bounds].size.width, 25)];
    [self setFrameSize:NSMakeSize([self frame].size.width, 25)];
    location.x = [self frame].size.width / [self segmentCount] * [self selectedSegment];
    [[self cell] setTrackingMode:NSSegmentSwitchTrackingSelectOne];
}

-(void)drawCenteredImage:(NSImage*)image inFrame:(NSRect)frame imageFraction:(float)imageFraction
{
    CGSize imageSize = [image size];
    CGRect rect= NSMakeRect(frame.origin.x + (frame.size.width-imageSize.width)/2.0, 
               frame.origin.y + (frame.size.height-imageSize.height)/2.0,
               imageSize.width, 
               imageSize.height ); 
    [image drawInRect:rect
                                      fromRect:NSZeroRect
                                     operation:NSCompositeSourceOver
                                      fraction:imageFraction
                                respectFlipped:YES
                                         hints:nil];
}

- (void)drawCenteredLabel:(NSString *)label inFrame:(NSRect)frame attributes:(NSDictionary *)attributes
{
    NSSize labelSize = [label sizeWithAttributes:attributes];
    CGRect rect = NSMakeRect(frame.origin.x + (frame.size.width - labelSize.width) * 0.50f,
                             frame.origin.y + (frame.size.height - labelSize.height) * 0.50f, // Subtract a pixel to make it look centered
                             labelSize.width,
                             labelSize.height);
    [label drawInRect:rect withAttributes:attributes];
}

- (void)drawRect:(NSRect)dirtyRect
{    
  NSRect rect = [self bounds];
  rect.size.height -= 1;
    
    [self drawBackgroud:rect];
    [self drawKnob:rect];
}

- (void)drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{
    NSImage *image = [self imageForSegment:segment];
    NSString *label = [self labelForSegment:segment];
    
    if (label != nil)
    {
        NSDictionary *attributes = @{ NSFontAttributeName : self.labelFont, NSForegroundColorAttributeName : [NSColor colorWithDeviceWhite:0.0f alpha:0.50f] };
        [self drawCenteredLabel:label inFrame:frame attributes:attributes];
    }
    else
    {
        float imageFraction;
        
        if ([[self window] isKeyWindow]) {
            imageFraction = .5;
        } else {
            imageFraction = .2;
        }
        
        [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
        
        [self drawCenteredImage:image inFrame:frame imageFraction:imageFraction];
    }
}

- (void)drawBackgroud:(NSRect)rect
{
  [_backgroundImage drawInRect:rect fromRect:rect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];

  for (int i = 0; i < [self segmentCount]; i++){
    CGFloat width = rect.size.width / [self segmentCount];
    CGFloat height = rect.size.height;
    NSRect custom_rect=NSMakeRect(width*i, rect.origin.y, width, height);

    NSString *label = [self labelForSegment:i];
    if (label != nil){
      NSDictionary *attributes = @{ NSFontAttributeName : self.labelFont, NSForegroundColorAttributeName : [_textColor colorWithAlphaComponent:0.6] };
      [self drawCenteredLabel:label inFrame:custom_rect attributes:attributes];
    }
  }

}

- (void)drawKnob:(NSRect)rect
{
  CGFloat width = rect.size.width / [self segmentCount];
  CGFloat height = rect.size.height;
  NSRect knobRect=NSMakeRect(location.x, rect.origin.y, width, height);

  [_knobImage drawInRect:knobRect fromRect:knobRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    
  int newSegment = (int)round(location.x / width);
  
  NSString *label = [self labelForSegment:newSegment];
  
  if (label != nil)
  {
      NSDictionary *attributes = @{ NSFontAttributeName : self.labelFont, NSForegroundColorAttributeName : _textColor };
      [self drawCenteredLabel:label inFrame:knobRect attributes:attributes];
  }
}

- (void)animateTo:(int)x
{
    float maxX = [self frame].size.width - ([self frame].size.width / [self segmentCount]);
    
    ANKnobAnimation *a = [[ANKnobAnimation alloc] initWithStart:location.x end:x];
    [a setDelegate:self];
    if (location.x == 0 || location.x == maxX){
        [a setDuration:_fastAnimationDuration];
        [a setAnimationCurve:NSAnimationEaseInOut];
    } else {
        [a setDuration:_slowAnimationDuration * ((fabs(location.x - x)) / maxX)];
        [a setAnimationCurve:NSAnimationLinear];
    }
    
    [a setAnimationBlockingMode:NSAnimationBlocking];
    [a startAnimation];
#if ! __has_feature(objc_arc)
    [a release];
#endif
}


- (void)setPosition:(NSNumber *)x
{
    location.x = [x intValue];
    [self display];
}

- (void)setSelectedSegment:(NSInteger)newSegment
{
    [self setSelectedSegment:newSegment animate:true];
}

- (void)setSelectedSegment:(NSInteger)newSegment animate:(bool)animate
{
    if(newSegment == [self selectedSegment])
        return;
    
    float maxX = [self frame].size.width - ([self frame].size.width / [self segmentCount]);
    
    int x = newSegment > [self segmentCount] ? maxX : newSegment * ([self frame].size.width / [self segmentCount]);
    
    if(animate)
        [self animateTo:x];
    else {
        [self setNeedsDisplay:YES];
    }
    
    [super setSelectedSegment:newSegment];
}


- (void)offsetLocationByX:(float)x
{
    location.x = location.x + x;
    float maxX = [self frame].size.width - ([self frame].size.width / [self segmentCount]);
    
    if (location.x < 0) location.x = 0;
    if (location.x > maxX) location.x = maxX;
    
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event
{
    BOOL loop = YES;
    
    NSPoint clickLocation = [self convertPoint:[event locationInWindow] fromView:nil];
    float knobWidth = [self frame].size.width / [self segmentCount];
    NSRect knobRect = NSMakeRect(location.x, 0, knobWidth, [self frame].size.height);
    
    if (NSPointInRect(clickLocation, [self bounds])) {
        NSPoint newDragLocation;
        NSPoint localLastDragLocation;
        localLastDragLocation = clickLocation;
        
        while (loop) {
            NSEvent *localEvent;
            localEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask];
            
            switch ([localEvent type]) {
                case NSLeftMouseDragged:
                    if (NSPointInRect(clickLocation, knobRect)) {
                        newDragLocation = [self convertPoint:[localEvent locationInWindow]
                                                                  fromView:nil];
                        
                        [self offsetLocationByX:(newDragLocation.x - localLastDragLocation.x)];
                        
                        localLastDragLocation = newDragLocation;
                        [self autoscroll:localEvent];
                    }             
                    break;
                case NSLeftMouseUp:
                    loop = NO;
                    
                    int newSegment;
                    
                    if (memcmp(&clickLocation, &localLastDragLocation, sizeof(NSPoint)) == 0) {
                        newSegment = floor(clickLocation.x / knobWidth);
                        //if (newSegment != [self selectedSegment]) {
                        [self animateTo:newSegment * knobWidth];
                        //}
                    } else {
                        newSegment = (int)round(location.x / knobWidth);
                        [self animateTo:newSegment * knobWidth];
                    }
                    
                    [self setSelectedSegment:newSegment];
                    [[self window] invalidateCursorRectsForView:self];
                    [self sendAction:[self action] to:[self target]];
                    
                    break;
                default:
                    break;
            }
        }
    };
    return;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)setDefaultDurations
{
    _fastAnimationDuration = 0.20;
    _slowAnimationDuration = 0.35;
}

@end