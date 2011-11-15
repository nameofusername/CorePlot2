//
//  SecondViewController.m
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize dataForChart;
@synthesize timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Second", @"Second");
		self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)timerFired
{
	[pieChart release];
	
	pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[pieChart applyTheme:theme];
	
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.hostedGraph = pieChart;
	
	pieChart.paddingTop = 20.0;
	pieChart.paddingBottom = 20.0;
	pieChart.paddingLeft = 20.0;
	pieChart.paddingRight = 20.0;
	
	pieChart.axisSet = nil;
	
	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
	
	pieChart.titleTextStyle = whiteText;
	//pieChart.title = @"Pie Chart";
	
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource = self;
	piePlot.pieRadius = 84.0;
	piePlot.labelOffset = -25.0f;
	piePlot.identifier = @"Pie Chart 1";
	piePlot.startAngle = M_PI_4;
	piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlot.centerAnchor = CGPointMake(0.5, 0.445);
	piePlot.delegate = self;
	[pieChart addPlot:piePlot];
	[piePlot release];
}

#pragma  mark - Plot Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return [self.dataForChart count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	if (index >= [self.dataForChart count]) {
		return nil;
	}
	
	if (fieldEnum == CPTPieChartFieldSliceWidth) {
		return [self.dataForChart objectAtIndex:index];
	} else {
		return [NSNumber numberWithInt:index];
	}
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
	CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index]];
	CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
	textStyle.color = [CPTColor whiteColor];
	label.textStyle = textStyle;
	[textStyle release];
	return [label autorelease];
}

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
	CPTFill *sliceFill;
	CGColorRef color = [[UIColor colorWithRed:index*0.1+0.3 green:index*0.2+0.1 blue:index*0.4+0.4 alpha:0.8] CGColor];
	sliceFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
	return sliceFill;
}

- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)piePlot recordIndex:(NSUInteger)index
{
	CGFloat offset = 0.0;
	
	if (index == [[[pieChart.title componentsSeparatedByString:@" "] lastObject] intValue]) {
		offset = piePlot.pieRadius / 10.0;
	}
	
	return offset;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[dataForChart release];
	[timer release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:
									[NSNumber numberWithDouble:20.0], 
									[NSNumber numberWithDouble:30.0], 
									[NSNumber numberWithDouble:10.0],
									[NSNumber numberWithDouble:25.0],
									[NSNumber numberWithDouble:15.0],
									nil];
	self.dataForChart = contentArray;
	
	[self timerFired];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:100.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
	pieChart.title = [NSString stringWithFormat:@"Selected index: %lu", index];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CABasicAnimation *basicAnimation = (CABasicAnimation *)anim;
	
	[piePlot removeAnimationForKey:basicAnimation.keyPath];
	[piePlot setValue:basicAnimation.toValue forKey:basicAnimation.keyPath];
	[piePlot repositionAllLabelAnnotations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
	//return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#if 0
	CGFloat margin = pieChart.plotAreaFrame.borderLineStyle.lineWidth + 5.0;
	
	CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CGRect plotBounds = piePlot.plotArea.bounds;
	CGFloat newRadius = MIN(plotBounds.size.width, plotBounds.size.height) / 2.0 - 6 * margin;
	
	CGFloat y = 0.0;
	
	if (plotBounds.size.width > plotBounds.size.height) {
		y = 0.5;
	} else {
		y = (newRadius + margin + 70) / plotBounds.size.height;
	}

	CGPoint newAnchor = CGPointMake(0.5, y);
	
	[CATransaction begin];
	{
		[CATransaction setAnimationDuration:1.0];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"pieRadius"];
		animation.toValue = [NSNumber numberWithDouble:newRadius];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"pieRadius"];
		
		animation = [CABasicAnimation animationWithKeyPath:@"centerAnchor"];
		animation.toValue = [NSValue valueWithBytes:&newAnchor objCType:@encode(CGPoint)];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"centerAnchor"];
	}
	[CATransaction commit];
#endif
}

@end
