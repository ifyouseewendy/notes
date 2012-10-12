# App Tag #

## Model ##

+ <models/app_tag.rb>

User 1__________* AppTag 1__________1 AppStatSummary
                    |*
                    |
                    |
                    |*
                   Apps

+ <config/hbase.rb>

added two tables:

APP_GROUP_SYNC_TABLE = "[test]appgroupsync"
APP_GROUP_STAT_TABLE = "[test]appgroupstat"

+ <lib/data_platform.rb>

added two methods:

Umeng::DataPlatform.set_app_group( group_id, app_keys, status )
Umeng::DataPlatform.get_app_group_stat( group_id, date, stats, period = :daily )

+ <models/app.rb>

added App#remove_app_tags

+ <models/app_stat_summary.rb>

added AppStatSummary#clear_stats
