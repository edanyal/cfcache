<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

InactiveExpirationCacheEntry Component IMPLEMENTS CacheEntry
	-This object is an interface for CacheEntry objects
	
Versions
	v0.1 - 	init(), getData()
--->
<cfcomponent 
	displayname="InactiveExpirationCacheEntry"
	output="false"
	extends="cache.CacheEntry"
	hint="Concrete CacheEntry implementation to perform Inactive Expiration caching">
	
	<cfset variables.keyAccessQueue = "" />
	<cfset variables.key = "" />
	<cfset variables.data = "" />
	<cfset variables.lastAccessTime = "" />
	<cfset variables.instanceName = "" />
	
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: init
	  		Initializes the InactiveExpirationCacheEntry
	  	Params:
	  		"instanceName" - Name of the instance this function belongs to
	  		"keyAccessQueue" - Referance to the keyAccessQueue
	  		"key" - The key for this Entry
	  		"data" - The data for this Entry
	 --->
	<cffunction name="init" access="public" output="false" returntype="cache.InactiveExpirationCacheEntry">
		<cfargument name="instanceName" type="string" required="true" />
		<cfargument name="keyAccessQueue" type="array" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		
		<cfset variables.instanceName = arguments.instanceName />
		<cfset variables.keyAccessQueue = arguments.keyAccessQueue />
		<cfset variables.key = arguments.key />
		<cfset variables.data = arguments.data />
		<cfset variables.lastAccessTime = Now() />
		
		<cfreturn this />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: getData
	  		Gets the data out of the entry, and keeps the keyAccessQueue optimized
	 --->
	<cffunction name="getData" access="public" output="false" returntype="any">
		<cflock name="keyAccessQueue_#instanceName#" timeout="5">
			<cfloop index="i" from="1" to="#ArrayLen(variables.keyAccessQueue)#">
				<cfif variables.keyAccessQueue[i] EQ variables.key>
					<cfset ArrayDeleteAt(variables.keyAccessQueue, i) />
					<cfset ArrayPrepend( variables.keyAccessQueue, variables.key ) />
					<cfbreak />
				</cfif>
			</cfloop>
		</cflock>
		<cfset variables.lastAccessTime = Now() />
		<cfreturn variables.data />
	</cffunction>
	
</cfcomponent>
	