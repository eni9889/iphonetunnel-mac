

#import "ITStatusBarView.h"

#define kAnimationFrameCount 20
#define kAnimationSleep 18

#import <unistd.h>


@implementation ITStatusBarView

- (id)initWithFrame:(NSRect)frame statusItem:(NSStatusItem*)statusItem menu:(NSMenu*)menu;
{
    self = [super initWithFrame:frame];
	if (self) {
		_menu = [menu retain];
		_statusItem = [statusItem retain];
		
		_leftImage = [[NSImage imageNamed:@"left_arrow.png"] retain];
		_rightImage = [[NSImage imageNamed:@"right_arrow-.png"] retain];
		_leftImageOff = [[NSImage imageNamed:@"left_arrow_off.png"] retain];
		_rightImageOff = [[NSImage imageNamed:@"right_arrow_off.png"] retain];
		_leftImageAlt = [[NSImage imageNamed:@"left_arrow_alt.png"] retain];
		_rightImageAlt = [[NSImage imageNamed:@"right_arrow_alt.png"] retain];
		_imageMask = [[NSImage imageNamed:@"arrow_mask.tif"] retain];
		
		NSAnimationProgress progMarks[] = {
            0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,
		0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0  };
		
		_animation = [[NSAnimation alloc] initWithDuration:0.8 animationCurve:NSAnimationEaseInOut];
		[_animation setDelegate:self];
		[_animation setFrameRate:0];
		[_animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
		int i;
		for (i = 0; i < kAnimationFrameCount; i++) {
			[_animation addProgressMark:progMarks[i]];
		}
		_animProgress = 1.0;
		
		_gray = YES;
	}
    return self;
}

- (void)setImageGray:(BOOL)yn
{
	_gray = yn;
	[self setNeedsDisplay:YES];
}

- (void)setImageAnimation:(BOOL)yn
{
	if (yn)
	{
		[_animation startAnimation];
	} else {
		[_animation stopAnimation];
		_animProgress = 1.0;
		[self setNeedsDisplay:YES];
	}

	_animate = yn;
}

- (void)animationDidEnd:(NSAnimation *)animation
{
	if (!_animate) {
		[_animation stopAnimation];
		_animProgress = 1.0;
		[self setNeedsDisplay:YES];
		return;
	}
	sleep(kAnimationSleep);
	[_animation startAnimation];
}

- (void)animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress
{
	_animProgress = progress;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect
{
	NSImage* leftImage;
	NSImage* rightImage;
	if (_menuIsVisible) {
		leftImage = _leftImageAlt;
		rightImage = _rightImageAlt;
	} else {
		if (_gray) {
			leftImage = _leftImageOff;
			rightImage = _rightImageOff;
		} else {
			leftImage = _leftImage;
			rightImage = _rightImage;
		}
	}
	
	
	[_statusItem drawStatusBarBackgroundInRect:[self frame] withHighlight:_menuIsVisible];
	
	NSPoint leftCurPoint = NSMakePoint((16 - (32+16))*_animProgress + 16+7+16, 11);
	NSPoint rightCurPoint = NSMakePoint((32+16 - 16)*_animProgress-7-16, 4);
	
	
	[leftImage dissolveToPoint:leftCurPoint fraction:1.0];
	[rightImage dissolveToPoint:rightCurPoint fraction:1.0];
	
	leftCurPoint = NSMakePoint((16 - (32+16))*_animProgress+7, 11);
	rightCurPoint = NSMakePoint(((32+16) - 16)*_animProgress-7+16,4);
	
	[leftImage dissolveToPoint:leftCurPoint fraction:1.0];
	[rightImage dissolveToPoint:rightCurPoint fraction:1.0];
	
	if (!_menuIsVisible) {
		[_imageMask compositeToPoint:NSMakePoint(0, 0) operation: NSCompositeDestinationOut fraction:1.0];
	}
}

- (void)mouseDown:(NSEvent *) theEvent
{
	_menuIsVisible = YES;
	[self setNeedsDisplay:YES];
	[_statusItem popUpStatusItemMenu:_menu];
	_menuIsVisible = NO;
	[self setNeedsDisplay:YES];
}	

- (void)dealloc
{
	[_imageMask release];
	[_leftImage release];
	[_leftImageAlt release];
	[_leftImageOff release];
	[_rightImage release];
	[_rightImageAlt release];
	[_rightImageOff release];
	[_menu release];
	[_statusItem release];
	[super dealloc];
}

@end
