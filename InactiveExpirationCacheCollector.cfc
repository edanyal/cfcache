<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

InactiveExpirationCacheCollector Componnent IMPLEMENTS CacheCollector
	-This object collects inactive entries
	
Versions
	v0.1 - 	init(), collect(), setInstance()
--->
<cfcomponent 
	displayname="InactiveExpirationCacheCollector"
	output="false"
	extends="cache.CacheCollector"
	hint="Concrete Cache Collector for Inactive Expiration">
	
	<!--- Member properties --->
	<cfset variables.cache = "" /> <!--- Cache Referance --->
	<cfset variables.keyAccessQueue = "" /> <!--- keyAccessQueue Referance --->
	<cfset variables.expirationInterval = "" /> <!--- Expiration interval for this cache instance --->
	<cfset variables.instanceName = "" /> <!--- this instance name --->
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: init
	  		Initializes the InactiveExpirationCacheCollector.
	  	Params:
	  		"cache" - Referance to the cache
	  		"keyAccessQueue" - Referance to the keyAccessQueue
	  		"expirationInterval" - Time in minutes for cache entries to expire if they're inactive
	 --->
	<cffunction name="init" access="public" returntype="cache.InactiveExpirationCacheCollector">
		<cfargument name="cache" type="Cache" required="true" />
		<cfargument name="keyAccessQueue" type="array" required="true" />
		<cfargument name="expirationInterval" type="numeric" required="true" />
		
		<cfset variables.cache = arguments.cache />
		<cfset variables.keyAccessQueue = arguments.keyAccessQueue />
		<cfset variables.expirationInterval = ( arguments.expirationInterval * -1  )/>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setInstanceName" access="public" returntype="void">
		<cfargument name="instanceName" type="string" required="true" />
		<cfset varaibles.instanceName = arguments.instanceName />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: collect
	  		Expunges inactive entries in the cache defined by our expirationInterval
	 --->
	<cffunction name="collect" access="public" returntype="void">
		<cfset var expirationTime = DateAdd("n", variables.expirationInterval, Now()) />
		<cfset var keysToRemove = 0 />
		<cfset var cacheEntry = "" />
		
		<cflock name="cache_#variables.instanceName#" timeout="30">
			<cflock name="keyAccessQueue_#variables.instanceName#" timeout="30">
				<cfloop index="i" from="1" to="#ArrayLen(keyAccessQueue)#">
					<cfset cacheEntry = variables.cache.get( variables.keyAccessQueue[i] ) />
					<cfif DateCompare( cacheEntry.getLastAccessTime(), expirationTime ) LT 1>
						<cfset keysToRemove = keysToRemove + 1 />
					<cfelse>
						<cfbreak />
					</cfif>
				</cfloop>
				<cfloop index="i" from="1" to="#keysToRemove#">
					<cfset variables.cache.remove( variables.keyAccessQueue[i] ) />
					<cfset ArrayDeleteAt(variables.keyAccessQueue, 1) />
				</cfloop>
			</cflock>
		</cflock>
	</cffunction>
	
</cfcomponent>