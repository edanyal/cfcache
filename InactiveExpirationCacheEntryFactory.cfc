<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

InactiveExpirationCacheEntryFactory Component IMPLEMENTS CacheEntryFactory
	-This object creates instances of InactiveExpirationCacheEntries
	
Versions
	v0.1 - 	init(), newCacheEntry()
--->
<cfcomponent 
	displayname="InactiveExpirationCacheEntryFactory"
	output="false"
	extends="cache.CacheEntryFactory"
	hint="Concrete CacheEntryFactory implementation to perform the creation of InactiveExpirationCacheEntries">
	
	<cfset variables.keyAccessQueue = "" />
	<cfset variables.instanceName = "" />
	
	<cffunction name="init" access="public" returntype="cache.InactiveExpirationCacheEntryFactory">
		<cfargument name="keyAccessQueue" type="array" required="true" />
		<cfset variables.keyAccessQueue = arguments.keyAccessQueue />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setInstanceName" access="public" returntype="void">
		<cfargument name="instanceName" type="string" required="true" />
		<cfset varaibles.instanceName = arguments.instanceName />
	</cffunction>
	
	<cffunction name="newCacheEntry" access="public" returntype="cache.CacheEntry">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		
		<cfreturn CreateObject('component', 'InactiveExpirationCacheEntry').init( 
		   			variables.instanceName, 
		   			variables.keyAccessQueue,
		   			arguments.key,
		   			arguments.value ) />
	</cffunction>
</cfcomponent>