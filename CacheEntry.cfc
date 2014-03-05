<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

CacheEntry Component
	-This object is an interface for CacheEntry objects
	
Versions
	v0.1 - 	init(), getData()
--->
<cfcomponent 
	displayname="CacheEntry"
	output="false"
	hint="CacheEntry Interface">
	
	<cffunction name="init" access="public" output="false" returntype="cache.CacheEntry">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		<!--- PURE VIRTUAL : MUST OVERRIDE --->
	</cffunction>
	
	<cffunction name="getData" access="public" output="false" returntype="any">
		<!--- PURE VIRTUAL : MUST OVERRIDE --->
	</cffunction>
	
</cfcomponent>
	