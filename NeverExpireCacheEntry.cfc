<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

NeverExpireCacheEntry Component IMPLEMENTS CacheEntry
	-This object is an interface for CacheEntry objects
	
Versions
	v0.1 - 	init(), getData()
--->
<cfcomponent 
	displayname="NeverExpireCacheEntry"
	output="false"
	extends="cache.CacheEntry"
	hint="Concrete CacheEntry implementation to perform caching which never expires">

	<cfset variables.key = "" />
	<cfset variables.data = "" />
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: init
	  		Initializes the NeverExpireCacheEntry
	  	Params:
	  		"key" - The key for this Entry
	  		"data" - The data for this Entry
	 --->
	<cffunction name="init" access="public" output="false" returntype="cache.NeverExpireCacheEntry">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		
		<cfset variables.key = arguments.key />
		<cfset variables.data = arguments.data />
		
		<cfreturn this />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: getData
	  		Gets the data out of the entry, and keeps the keyAccessQueue optimized
	 --->
	<cffunction name="getData" access="public" output="false" returntype="any">
		<cfreturn variables.data />
	</cffunction>
	
</cfcomponent>
