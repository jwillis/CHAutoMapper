CHAutoMapper maps values from one object type to another. But more importantly, it avoids boring mapping code by automatically mapping camel case names to other naming conventions such as underscore naming.

## Example Uses
* Automatically map a JSON response from a web api that serializes using underscore naming to an NSObject subclass that uses camel case property names.
* Map arrays and object graphs.
* Reuse mapping instances via a mapping registry.
* Plug in custom naming conventions.
* Override the naming convention when necessary.
* Generate mapping code if the objects don't use naming conventions.

## Getting Started
Let's say we're consuming a web api that serializes a sports team object using underscore naming. So, the JSON response would be:
    
    { "id": 1, "name": "Bulls", head_coach_id: 1 }

CHAutoMapper leaves it up to you (or your favorite library) to parse the JSON to an NSDictionary.

	NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:kNilOptions error:NULL];

When you have the NSDictionary, it can be mapped to a Team model object in Objective-C. Without auto mapping, we would write something like:
    
    Team *team = [[Team alloc] init];
    team.teamId = [dictionary objectForKey:@"id"];
    team.name = [dictionary objectForKey:@"name"];
    team.headCoachId = [dictionary objectForKey:@"head_coach_id"];

That kind of manual mapping can get very tedious. Instead of that, let's bring auto mapping into the mix, and let's map knowing the source dictionary is using underscore naming. This will have the same result, but less code.
    
	[[CHObjectMapper shared] mapClass:[Team class]];
    Team *team  = [[Team alloc] initWithDictionary:dictionary];

The shared CHObjectMapper (singleton) only needs to be told once per app how to map the Team class. From then on, initWithDictionary will populate the Team object with the values in the dictionary parameter.

## Array Associations
Now, we add a players array property to the Team object. So, the JSON response would be:
    
    {
    	"id": 1, "name": "Bulls", "head_coach_id": 4,
    	"players": [
    		{ "id": 8, "first_name": "Derrick", "last_name": "Rose" },
    		{ "id": 9, "first_name": "Joakim", "last_name": "Noah" }
    	]
    }

To map from the NSDictionary, including the instances in the players array:

	[[CHObjectMapper shared] mapClass:[Team class] withOverride:^(CHObjectMapping *team) {
        [team hasMany:[Player class] propertyName:@"players"];
    }];

    Team *team  = [[Team alloc] initWithDictionary:dictionary];

## Object Associations
Now, we add a headCoach object property to the Team object. So, our JSON response would be:
    
    {
    	"id": 1, "name": "Bulls", "head_coach_id": 4,
    	"head_coach": { "id" : 4, "first_name": "Tom", "last_name": "Thibodeau" },
    	"players": [
    		{ "id": 8, "first_name": "Derrick", "last_name": "Rose" },
    		{ "id": 9, "first_name": "Joakim", "last_name": "Noah" }
    	]
    }
    
To configure the mapper to include the headCoach relationship, we would write:

	[[CHObjectMapper shared] mapClass:[Team class] withOverride:^(CHObjectMapping *team) {
        [team belongsTo:[Coach class] propertyName:@"headCoach"];
        [team hasMany:[Player class] propertyName:@"players"];
    }];

    Team *team  = [[Team alloc] initWithDictionary:dictionary];
		
## Custom Naming Conventions
Perhaps the source objects are using a custom naming convention not already provided in this library. It is easy to auto map a custom convention. Let's see how we would do that when our web api is serving up Pascal cased objects, as is often the case for .NET platforms. Our JSON response looks like:
		
    {
    	"TeamID": 1, "Name": "Bulls", "HeadCoachID": 4,
    }

And our mapping:

    [[CHObjectMapper shared] mapWithMapping:[CHObjectMapping mappingForClass:[Team class]
        keyFromPropertyName:^NSString *(NSString *propertyName, Class targetClass) {
            return [[propertyName pascalizeFromCamel] stringByReplacingOccurrencesOfString:@"Id" withString:@"ID"];
        }]];

    Team *team  = [[Team alloc] initWithDictionary:dictionary];

## Overriding Conventions
Maybe our JSON occasionally breaks its own naming convention. We can explicitly map that property. So, to map the following JSON response:
		
    { "id": 1, "fname": "Derrick", "last_name": "Rose" }

For that response, we would use this mapping:

    [CHObjectMapper map:[Player class] withOverride:^(CHObjectMapping *player) {
		[player mapPropertyNamed:@"firstName" toKey:@"fname"];
	}];

    Player *player  = [[Player alloc] initWithDictionary:dictionary];

## Mapping from non-JSON sources
CHAutoMapper is not limited to JSON sources, but can be used with any KVC source.

## More to come for CHAutoMapper
* Auto discover relationships. This will take some inflector code.
* More naming conventions.
* Better docs and test cases.
* Your ideas and contributions ...
