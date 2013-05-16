

#import <Foundation/Foundation.h>


@interface PathHelper : NSObject {

}

+ (BOOL)createPathIfNecessary:(NSString*)path;

+ (NSString*)documentDirectoryPathWithName:(NSString*)name;

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name;

@end
