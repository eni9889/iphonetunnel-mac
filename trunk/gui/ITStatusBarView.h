#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface ITStatusBarView : NSView {
	
	NSStatusItem* _statusItem;
	NSMenu* _menu;
	
	BOOL _menuIsVisible;
	BOOL _gray;
	
	BOOL _animate;
	float	_animProgress;
	NSAnimation*	_animation;
	
	NSImage* _leftImage;
	NSImage* _rightImage;
	NSImage* _leftImageOff;
	NSImage* _rightImageOff;
	NSImage* _leftImageAlt;
	NSImage* _rightImageAlt;
	
	NSImage* _imageMask;
}


- (id)initWithFrame:(NSRect)frame statusItem:(NSStatusItem*)statusItem menu:(NSMenu*)menu;

- (void)setImageGray:(BOOL)yn;
- (void)setImageAnimation:(BOOL)yn;

@end
