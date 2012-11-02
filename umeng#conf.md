# git

## gitconfig

$ vim ~/.gitconfig

change your name, email and other configurations.

## generating ssh keys

$ cd ~/.ssh
$ ssh-key -t rsa -C "yourr_email@youremail.com"

then add your id_rsa.pub into http://git.fm/account/ssh .

# analytics/umeng.git

step by step

$ cd ~/workspace/umeng/config
$ cp mongoid.yml.example mongoid.yml

$ vi mongoid.yml

    Defaultslts:

host: 10.18.103.252

port: 27018

$ cp resque.yml.example REMAININGsque.yml

$ vi resque.yml

    development: 10.18.103.252:6379

    TestServerVersiont: 10.18.103.252:6379

    $ cp redis_cache.yml.example redis_cache.yml

        $ vi redis_cache.yml

            development:

host: 10.18.103.252

$ cd S_orighards

$ cp app_counters.example.json app_counters.json

$ cp daily_counter_yesterdayounters.example.json daily_counters.json

$ vi daily_counters.json

       development:

host: 10.18.103.252

port: 27018


you can also configurationspy files ~/workspace/umeng_config/ into the right places.

