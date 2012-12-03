### AppTag ###

* Association

    ```ruby
    User (1)----------(*) AppTag (*)----------(*) App

    User (1)----------(1) AppStatSummary
    AppTag (1)----------(1) AppStatSummary
    ```

* 展示页

    + apps#index 汇总数据

        - 今日/昨日: 新增、活跃、启动、累计

            ```ruby
            all_apps.count <= 50  # 线上AppCounter累加
            all_apps.count  > 50  # 取AppStatSummary数据 (app_stat_summary_batch.rake)
            ```

        - 昨日: 独立新增、独立活跃、独立启动

            ```ruby
            Umeng:DataPlatform.get_app_group_stats(all_tag)
            ```

    + apps#trend 趋势分析

        ```ruby
        all_apps.count <= 50  # 线上DailyCounter累加
        all_apps.count  > 50  # 取AppStatSummary数据 (app_stat_summary_batch.rake)
        ```

* 脚本任务

    + 初始为现有 app 打标签

        ```ruby
        # <sync_app_tag.rake>
        $ rake umeng:default_app_tag_update
        ```

    + AppTag 定时后台同步脚本

        ```ruby
        # <sync_app_tag.rake>
        $ rake umeng:sync_app_tag
        ```

    + AppTag resque 任务
        - 新增用户时, 跑出"全部", "未分组"标签
        - 新增app时, 自动打上相应标签

          ```ruby
          # <default_app_tags_updater.rb>
          $ redis-server
          $ resque-web
          $ RAILS_ENV=development QUEUE=app_tags rake resque:work
          ```

    + AppStatSummary 定时后台同步脚本

        ```ruby
        # <app_stat_summary_batch.rake>
        $ rake umeng:update_app_stat_summary  # apps#index
        $ rake umeng:update_app_stat_summary_trends  # apps#trend
        ```



