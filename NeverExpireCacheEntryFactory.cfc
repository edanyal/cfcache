<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

NeverExpireCacheEntryFactory Component IMPLEMENTS CacheEntryFactory
	-This object creates instances of NeverExpireCacheEntries
	
Versions
	v0.1 - 	init(), newCacheEntry()
--->
<cfcomponent 
	displayname="NeverExpireCacheEntryFactory"
	output="false"
	extends="cache.CacheEntryFactory"
	hint="Concrete CacheEntryFactory implementation to perform the creation of NeverExpireCacheEntryFactory">
	
	<cfset variables.instanceName = "" />
	
	<cffunction name="init" access="public" returntype="cache.NeverExpireCacheEntryFactory">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setInstanceName" access="public" returntype="void">
		<cfargument name="instanceName" type="string" required="true" />
		<cfset varaibles.instanceName = arguments.instanceName />
	</cffunction>
	
	<cffunction name="newCacheEntry" access="public" returntype="cache.CacheEntry">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		
		<cfreturn CreateObject('component', 'NeverExpireCacheEntry').init( 
		   			arguments.key,
		   			arguments.value ) />
	</cffunction>
</cfcomponent>