#ifndef KOMacros_H
#define KOMacros_H

#define USER_DEFAULT                [NSUserDefaults standardUserDefaults]
#define FileManager 				[NSFileManager defaultManager]

//沙盒目录
#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_DOC_PATH				[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_TMP_PATH				NSTemporaryDirectory()
#define APP_LIBRARY_PATH			[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_BUNDLE_PATH				[[NSBundle mainBundle] resourcePath]

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define KeyWindow               [[UIApplication sharedApplication] keyWindow]

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#define IS_4_INCH                   (APP_SCREEN_HEIGHT > 480.0)

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)//用来获取手机的系统，判断系统是多少

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// 是否iPad
#define isPad	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *sharedInstance = nil; \
 \
+ (classname *)sharedInstance \
{ \
	@synchronized(self) \
	{ \
		if (sharedInstance == nil) \
		{ \
			sharedInstance = [[self alloc] init]; \
		} \
	} \
	 \
	return sharedInstance; \
} \


// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil

#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))

#pragma mark - OTHER

#ifdef DEBUG
#define DEBUGLINE [NSString stringWithFormat:@"m:%d",__LINE__]
#define DEBUGS [NSString stringWithFormat:@"%sm:%d ",__PRETTY_FUNCTION__,__LINE__]
#define DEBUGLog NSLog(@"%@",DEBUGS);
#define DEBUGMSG(msg,...) NSLog(@"%@\n%@",[NSString stringWithFormat:msg, ## __VA_ARGS__],DEBUGS);
#define DEBUGERR(msg,...) NSLog(@"<Error> %@%@",DEBUGS,[NSString stringWithFormat:msg, ## __VA_ARGS__]);
#define DEBUGdealloc NSLog(@" >*** %@ %p",DEBUGS,self);
#define DEBUG_START_TIMER debug_start = [NSDate timeIntervalSinceReferenceDate]; DEBUGLog(@"START_TIMER");
#define DEBUG_END_TIMER(msg,...)  NSTimeInterval debug_stop = [NSDate timeIntervalSinceReferenceDate]; DEBUGMSG(@"END_TIMER %f: %@",debug_stop-debug_start,[NSString stringWithFormat:msg, ## __VA_ARGS__]);
#define DEBUGUNLOADMSG NSLog(@" >************************* %@ %p",DEBUGS,self);

#else
#define DEBUGLINE @""
#define DEBUGS @""
#define DEBUGLog
#define DEBUGMSG(msg,...)
#define DEBUGERR(msg,...)
#define DEBUGdealloc
#define DEBUG_START_TIMER
#define DEBUG_END_TIMER(msg,...)
#define DEBUGUNLOADMSG @""
#endif

#define appDelegate	(HIAppDelegate *)[[UIApplication sharedApplication] delegate]

#pragma mark - 懒人模式

#define PS @property (nonatomic,strong)
#define PW @property (nonatomic,weak)
#define PA @property (nonatomic,assign)
#define PC @property (nonatomic,copy)

#define KOString @property (nonatomic,copy) NSString

#define KOView   @property (nonatomic,strong) UIView
#define KOImage   @property (nonatomic,strong) UIImage
#define KOID   @property (nonatomic,strong) id

#define KOFloat  @property (nonatomic,assign) CGFloat
#define KOInt    @property (nonatomic,assign) NSInteger
#define KOBool   @property (nonatomic,assign) BOOL

#define KOArray @property (nonatomic,strong) NSArray
#define KOMutableArray @property (nonatomic,strong) NSMutableArray

#define KODictionary @property (nonatomic,strong) NSDictionary
#define KOMutableDictionary @property (nonatomic,strong) NSMutableDictionary

#define KODate @property (nonatomic,strong) NSDate

#endif