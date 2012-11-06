# 一致性检测

### Basic Check Methods

+ Sum check

  - 对 各项指标 针对 各过滤条件 进行和值检验。

    * 指标： 新增用户、启动次数、活跃用户、活跃率、升级用户
    * 过滤条件： 渠道、版本、分群

  - 1\. 过滤条件 _只包含_ **渠道、版本** 时，有如下规则：

      * 某项指标（eg. 新增用户）的值
          == 该指标经 **各个渠道** 过滤后的 值之和
          == 该指标经 **各个版本** 过滤后的 值之和
          == 该指标经 **各个渠道与各个版本** 交叉过滤后的 值之和
      * 指标m经 **渠道c** 过滤后的值 == 指标m经 **渠道c** 与 **各个版本** 交叉过滤后的 值之和
      * 指标m经 **版本v** 过滤后的值 == 指标m经 **版本v** 与 **各个渠道** 交叉过滤后的 值之和

  - 2\. 过滤条件 _包含_ **分群** 时，有如下规则：（由于**分群**中包含了 时间、地域、自定义事件 的筛选，故可将分群看作一组过滤条件的集合，渠道、版本只相当于分群中的一个元素。由此，对于分群的和值检验与对渠道和版本的检验略有不同。)

      * 指标m经 **分群s** 过滤后的值 == 指标m经 **分群s** 与 **各个渠道** 交叉过滤后的 值之和
      * 指标m经 **分群s** 过滤后的值 == 指标m经 **分群s** 与 **各个版本** 交叉过滤后的 值之和
      * 指标m经 **分群s** 过滤后的值 == 指标m经 **分群s** 与 **各个渠道与各个版本** 交叉过滤后的 值之和
      * ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
      * 如果 **分群s1** 与 **分群s2, 分群s3, ..分群sn** 可组成一个全集，有如下规则：

          ```ruby
          eg.
          分群s1 = { 日期 <  '2012-10-01', 国家 == { '中国' } }
          分群s2 = { 日期 >= '2012-10-01' }
          分群s3 = { 国家 == { 除'中国'外的所有国家 } }
          ```

        - 指标m经 **渠道c** 过滤后的值 == 指标m经 **渠道c** 与 **各个分群** 交叉过滤后的 值之后
        - 指标m经 **渠道c** 过滤后的值 == 指标m经 **渠道c** 与 **各个分群与各个版本** 交叉过滤后的 值之后
        - 指标m经 **版本v** 过滤后的值 == 指标m经 **版本v** 与 **各个分群** 交叉过滤后的 值之后
        - 指标m经 **版本v** 过滤后的值 == 指标m经 **版本v** 与 **各个分群与各个渠道** 交叉过滤后的 值之后

  - 3\. ___pseudo-code___

      ```ruby
      metric = [ install, launch, active, active_rate, upgrade ]

      COUNT( metric.sum_by_channels( c1, c2, ..cn ) ).should == COUNT( metric )
      COUNT( metric.sum_by_versions( v1, v2, ..vn ) ).should == COUNT( metric )

      COUNT( metric.by_channel(c1).sum_by_versions( v1, v2, ..vn ) ).should == COUNT( metric.by_channel(c1) )
      COUNT( metric.by_version(v1).sum_by_channels( c1, c2, ..cn ) ).should == COUNT( metric.by_channel(v1) )
      <=> COUNT( metric.sum_by_filters( (c1,v1), (c2,v2), ..(cn,vn) ).should == COUNT( metric )

      => COUNT( metric.by_segment(s1).sum_by_channels( c1, c2, ..cn ) ).should == COUNT( metric.by_segment(s1) )
      => COUNT( metric.by_segment(s1).sum_by_versions( v1, v2, ..vn ) ).should == COUNT( metric.by_segment(s1) )
      <=> COUNT( metric.by_segment(s1).sum_by_filters( (c1,v1), (c2,v2), ..(cn,vn) ).should == COUNT( metric.by_segment(s1) )

      # as segment is a set of filters( {date, location, event} ),
      # it is different from channel|version, channel|version is just like a sub-element of segment.
      => COUNT( metric.by_channel(c1).sum_by_segments( s1, s2, ..sn ) ).maybe != COUNT( metric.by_channel(c1) )

      # if segment_a = { date < '2012-10-01' }, segment_b = { date >= '2012-10-01' }
      => COUNT( metric.by_channel(c1).sum_by_segments( segment_a, segment_b ) ).should == COUNT( metric.by_channel(c1) )
      # if segment_a = { date < '2012-10-01' && location = {'China'} }, segment_b = { date >= '2012-10-01' }, segment_c = { location != {'China'} }
      => COUNT( metric.by_version(v1).sum_by_segments( segment_a, segment_b, segment_c ).should == COUNT( metric.by_version(v1) )
      # if s1 = A1, s2 = A2, ..sn = An ( { A1, A2, ..An } == { :all } )
      => COUNT( metric.by_channel(c1).sum_by_segments( s1, s2, .. sn ) ).should == COUNT( metric.by_channel(c1) )

      ```

+ Reversion check

  - 对 **各项指标** 针对 **各过滤条件之间** 进行反转检验

  - 前端： **渠道、版本** 页面下**各个指标**值 == **各个指标** 页面下通过**渠道、版本**过滤后的值

  - 后端： 由于 **分群** 不像 **渠道、版本** 有专门的展示页，所以后端对方法调用的检验需要加上分群与渠道、版本的交叉

      ```ruby
      metric = [ install, launch, active, active_rate, upgrade ]

      filter = [ channel, segment, version ]
      # filter vs. metric
      COUNT( filter.get_daily_metric ).should == COUNT( metric.get_daily_by_filter )
      # filter vs. filter
      COUNT( filter1.get_daily_metric_by_filter2 ).should == COUNT( filter2.get_daily_metric_by_filter1 )
      COUNT( filter1.get_daily_metric_by_filter2_and_filter3 ).should
          == COUNT( filter2.get_daily_metric_by_filter1_and_filter3 )
          == COUNT( filter3.get_daily_metric_by_filter1_and_filter2 )

      ```

+ Consistency check ( between tables and charts )

  - 图表间数据的一致性检验 （主要检验出现在多处的相同指标数据）

+ Optional check

  - time check

      * **日/周/月** 级数据的加和检验

      * **今日 / 昨日 / 之前7天 / 之前30天** 时间标签的检验

  - rate check ( :acceptable => (99.x%..100.0%)  )

- - -

### 页面检查

1\. **新增用户**

  + sum_check

2\. **启动次数**

  + sum_check

3\. **活跃用户**

  + sum_check

4\. **版本分布**

  + 全部版本页

    ```ruby
    metric = [ :launch, :install, :acitve ]

    # <1. Table('Top 10 版本趋势') ~> reverse_check
    version.get_daily_metric = metric.get_daily_by_version

    # <2. Table('版本统计') ~> consistency_check(:table)
    Table('版本统计')['时段内版本用户'].should == Table('版本统计')['新增用户'] + Table['升级用户']

    # <3. ~> consistency_check(:table_table)
    Table('Top 10 版本趋势').top_10_versions.should == Table('版本统计').versions.first(10)
    Table('Top 10 版本趋势').metric.date_filter(:today | :yesterday).should in Table('版本统计').metric.tab_filter(:today | :yesterday)
    ```

  + 版本详情页

    ```ruby
    # <1.1 Chart('日趋势变化') ~> reverse_check
    metric = [ :upgrade ]
    filter = [ :channel, :segment ]

    version.get_daily_metric.should == metric.get_daily_by_version
    version.get_daily_metric_by_channel(c1).should == c1.get_daily_metric_by_version

    # <1.2 Chart('日趋势变化') ~> sum_check
    metric = [ :launch, :install, :active, :upgrade ]
    version.get_daily_metric_by_channels( c1, c2, ..cn ).should == version.get_daily_metric
    version.get_daily_metric_by_segment(s1).sum_by( c1, c2, ..cn ).should == version.get_daily_metric_by_segment(s1)

    # <2 Chart('版本用户来源') ~> consistency_check(:table_table), ( optional_check(:time) )
    Chart('版本用户来源')['新增用户渠道分布'].should == version.get_install_by_channels( c1, c2, .. cn )
    Chart('版本用户来源')['升级用户渠道分布'].should == version.get_upgrade_by_channels( c1, c2, .. cn )
    Chart('版本用户来源')['升级用户版本来源'].should == ?

    ```

5\. **行业数据**

  + consistency_check(:table_table)

    ```ruby
    Table('行业数据')['我的数据']['日新增用户'] = Table('新增用户明细')['新增用户'][:yesterday]
    Table('行业数据')['我的数据']['日启动次数'] = Table('启动次数明细')['启动次数'][:yesterday]
    Table('行业数据')['我的数据']['日活跃用户'] = Table('活跃用户明细')['活跃用户'][:yesterday]
    Table('行业数据')['我的数据']['平均每次使用时长'] = Table('新增用户明细')['新增用户'][:yesterday]
    Table('行业数据')['我的数据']['上周活跃用户'] = Table('活跃用户明细')['周活跃用户'][:last_week]
    Table('行业数据')['我的数据']['上周活跃率'] = Table('活跃用户明细')['周活跃率'][:last_week]
    Table('行业数据')['我的数据']['上月活跃用户'] = Table('活跃用户明细')['月活跃用户'][:last_month]
    Table('行业数据')['我的数据']['上月活跃率'] = Table('活跃用户明细')['月活跃率'][:last_month]
      ```

6\. **设备终端**

  + sum_check

    ```ruby
    metric = [ :install, :launch ]
    filter = [ :channel, :segment, :version ]
    attribute = [ :device, :os_version, :resolution ]
    ```

7\. **网络及运营商**

  + sum_check

    ```ruby
    metric = [ :install, :launch ]
    filter = [ :channel, :segment, :version ]
    attribute = [ :access, :carrier ]
    ```

8\. **地域**

  + sum_check

    ```ruby
    metric = [ :install, :launch ]
    filter = [ :channel, :segment, :version ]
    attribute = [ :country, :province ]
    ```

9\. **渠道**

  + 全部渠道页

    ```ruby
    metric = [ :install, :active, :launch, :duration, :retention ]

    # <1. Table('Top 10 渠道趋势') ~> reverse_check
    channel.get_daily_metric = metric.get_daily_by_channel

    # <2. ~> consistency_check(:table_table)
    Table('Top 10 渠道趋势').top_10_versions.should == Table('渠道统计')['全部'].versions.first(10)
    Table('Top 10 渠道趋势').metric.date_filter(:today, :yesterday).should == Table('渠道统计').metric.tab_filter(:today, :yesterday)
    ```

  + 渠道详情页

    ```ruby
    # <1. Chart('日趋势变化') ~> sum_check
    metric = [ install, active, launch, duration, retention ]
    channel.get_daily_metric_by_versions( v1, v2, ..vn ).should == channel.get_daily_metric
    channel.get_daily_metric_by_segment(s1).sum_by( c1, c2, ..cn ).should == channel.get_daily_metric_by_segment(s1)

    # <2. Chart('用户来源') ~> consistency_check(:chart_chart), optional_check(:time)
    Chart('用户来源')['设备'][:last_7_days].should == Chart('Top 10机型')[:last_7_days]['channel']['install'].map {|x| x/sum}
    Chart('用户来源')['国家'][:last_7_days].should == Chart('Top 10国家')[:last_7_days]['channel']['install'].map {|x| x/sum}
    Chart('用户来源')['省市'][:last_7_days].should == Chart('Top 10省市')[:last_7_days]['channel']['install'].map {|x| x/sum}
    Chart('用户来源')['版本'][:last_7_days].should == Chart('版本-日趋势变化')[:last_7_days]['channel']['install']['versions'].map {|x| x/sum}
    ```

10\. **留存用户**

  + sum_check

    ```ruby
    filter = [ :channel, :version ]
    ```

11\. **使用时长**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + optional_check(:rate)

12\. **使用频率**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + optional_check(:rate)

13\. **访问深度**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + optional_check(:rate)

14\. **使用间隔**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + optional_check(:rate)

15\. **页面访问**

  + optional_check(:rate)

    ```ruby
    Table('访问详情')['跳出率'|'跳转比例']
    ```

16\. **事件统计**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + reverse_check ?

17\. **事件转化**

  + sum_check

    ```ruby
    filter = [ :channel, :segment, :version ]
    ```

  + consistency_check(:table_table)

    ```ruby
    Table('漏斗列表')['最近一周转化率'].should == Table('转化率分析')['总体转化率']
    ```


