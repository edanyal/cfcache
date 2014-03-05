<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

CacheEntryFactory Component
	-This object is an interface for CacheEntryFactory objects
	
Versions
	v0.1 - 	newCacheEntry
--->
<cfcomponent 
	displayname="CacheEntryFactory"
	output="false"
	hint="CacheEntryFactory Interface">
	
	<cffunction name="newCacheEntry" access="public" output="false" returntype="cache.CacheEntry">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		<!--- PURE VIRTUAL : MUST OVERRIDE --->
	</cffunction>
	
</cfcomponent>