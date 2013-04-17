# REQUIREMENT

Add a search frame in app-list. Get the results by real time (when user create/update/destroy apps).

1. Preload specific numbers(PRELOAD_APPS_NUM=500) apps to make the app-list. User can direct to specific app page by app-list.

2. When searching(preload partial apps) apps, ajax requests the results.

# PREPARATION

1. Caching with Action Controller
  <1. page caching, for static page. # only :file_store
  <2. action caching, implemented by fragment caching and an around_filter. # [ caches_action | expire_action ]
  <3. fragment caching.

2. Cache stores (/config/environments/development.rb)
  <1. config.cache_store = :file_store
  <2. config.cache_store = :memory_store
  <3. config.cache_store = :mem_cache_store

  <4. config.cache_store = :null_store (in dev/test env, easily diable the Rails.cache)
  <5. config.cache_store = MyCacheStore.new

  use Rails.cache.[ read(key) | write(key, value) | fetch(key) do .. end | delete | clear ] directly

3. Sweepers
    observe SomeClass

    def after_create(app)
      expire_action_for(app)
    end
    ...

4. Others
  <1. Query Caching: when same query for request, use cached results.
                     when same query running against database, use cached results.
  <2. Conditional Get Support: response to unchanged GET requests.

# IMPLEMENTION

## interfaces
  :get_preload_apps
  :get_all_apps
  :search_apps

## Simply use the Rais.cache to cache and expire.
1. caches_action can work with GET/POST, caching the params with :proc. But expire_action cannot expire the params, can only use the Rails.cache.clear.
2. sweeper still has the same problems, also seemingly cannot work without ActiveRecord.

## Solution
Seperate cache by user, so that when expiring expire the specific user's cache.

Put a cache_index hash into cache, and use it to keep the specifc user's key into caching.
cache_index["_PRELOAD_APPS_"] = user_id + "#PRELOAD_APPS" # key to cache preload apps
cache_index["_ALL_APPS_"] = user_id + "#ALL_APPS" # key to cache all apps
cache_index{query} = user_id + ":" + query # key to cache query"

when expiring, expire cache based on cache_index.

