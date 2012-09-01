

#import <Foundation/Foundation.h>
#import <BackRow/BRBaseParserDelegate.h>

@class ntvMediaProvider;



@interface ntvRssDelegate : BRBaseParserDelegate
{
    NSString *          _filePath;
	NSString *			_currentElement;
	NSString *			_currentParent;
    NSXMLParser *       _parser;
	int					_currentType;
	NSMutableArray *	_tempArray;
	BOOL				_primaryGenre;
	NSMutableDictionary *_currentDict;
	NSMutableString		*_currentString;
	
	id					_parentController;
	NSMutableArray		*_itemArray;
	NSString			*_mainTitle;
}

- (id) initWithParentController: (id) theParent;
- (void) dealloc;
- (void) weakLinkToParser: (NSXMLParser *) parser;


- (void)parser:(id)fp8 didStartElement:(id)fp12 namespaceURI:(id)fp16 qualifiedName:(id)fp20 attributes:(id)fp24;
- (void)parser:(id)fp8 didEndElement:(id)fp12 namespaceURI:(id)fp16 qualifiedName:(id)fp20;
- (void)parser:(id)fp8 foundCharacters:(id)fp12;
@end
